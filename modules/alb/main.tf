# Security group for public Application Load Balancer
resource "aws_security_group" "alb_sg" {

  name = "${var.environment}-alb-sg"

  description = "Security Group for ALB"

  vpc_id = var.vpc_id

  # Allow inbound HTTP (80) from internet
  ingress {
    description = "Allow inbound HTTP (80) from internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic
  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # semantically equivalent to all ports
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Tags for identification
  tags = merge(
    var.alb_tags,
    {
      Name = "${var.environment}-alb-sg"
    }
  )
}

# Creates Application Load Balancer
resource "aws_alb" "tf_alb" {
  name               = "${var.environment}-tf-alb"
  internal           = false
  load_balancer_type = "application"
  subnets            = var.public_subnet_ids
  security_groups    = [aws_security_group.alb_sg.id]
  tags               = var.alb_tags
}

# Creates Target Group
# Target group for forwarding ALB traffic to EC2 instances
resource "aws_lb_target_group" "app_tg" {

  # Target group name
  name = "${var.environment}-app-target-group"

  # Application port on EC2 instances
  port = var.target_port

  # Protocol used between ALB and EC2
  protocol = "HTTP"

  # Existing VPC ID
  vpc_id = var.vpc_id

  # Register EC2 instances by instance ID
  target_type = "instance"

  # Health check configuration
  health_check {

    # Endpoint path to check
    path = "/"

    # Health check protocol
    protocol = "HTTP"

    # Expected success response
    matcher = "200"

    # Consecutive successful checks before healthy
    healthy_threshold = 2

    # Consecutive failed checks before unhealthy
    unhealthy_threshold = 2

    # Time between checks
    interval = 30

    # Health check timeout
    timeout = 5
  }

  # Tags for identification
  tags = merge(
    var.alb_tags,
    {
      Name = "${var.environment}-app-target-group"
    }
  )
}

# Creates ALB Listener
resource "aws_lb_listener" "lb_l" {
  load_balancer_arn = aws_alb.tf_alb.arn
  port              = "80"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }
}