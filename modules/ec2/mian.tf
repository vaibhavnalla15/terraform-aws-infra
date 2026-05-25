# Security group for private EC2 instance
resource "aws_security_group" "ec2_sg" {

  # Security group name
  name = "${var.environment}-ec2-sg"

  # Description for identification
  description = "Security group for private EC2 instance"

  # Attach security group to existing VPC
  vpc_id = var.vpc_id

  # Allow SSH access only from trusted IPs
  ingress {
    description = "Allow SSH access"

    from_port = 22
    to_port   = 22

    protocol = "tcp"

    # Trusted IP CIDR blocks
    cidr_blocks = var.allowed_ssh_cidr
  }

  # Allow all outbound internet traffic 
  egress {
    description = "Allow outbound internet access"

    from_port = 0
    to_port   = 0

    protocol = "-1"

    cidr_blocks = ["0.0.0.0/0"]
  }

  # Tags for identification
  tags = merge(
    var.tags,
    {
      Name = "${var.environment}-ec2-sg"
    }
  )
}

# Creates IAM role for EC2 instance
resource "aws_iam_role" "ec2_role" {

  # IAM role name
  name = "${var.environment}-ec2-role"

  # Trust policy allowing EC2 to assume this role
 assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = "ec2.amazonaws.com"
        }

        Action = "sts:AssumeRole"
      }
    ]
  })

  # Tags for identification
  tags = merge(
    var.tags,
    {
      Name = "${var.environment}-ec2-role"
    }
  )
}

# Attach existing S3 access policy to EC2 IAM role
resource "aws_iam_role_policy_attachment" "s3_access" {

  # EC2 IAM role name   
  role = aws_iam_role.ec2_role.name

  # Reuse S3 IAM policy created earlier
  policy_arn = var.s3_policy_arn
}

# Creates an IAM Instance Profile for EC2
resource "aws_iam_instance_profile" "ec2_profile" {

  # Instance profile name
  name = "${var.environment}-ec2-instance-profile"

  # IAM role attached to instance profile
  role = aws_iam_role.ec2_role.name
}

# Creates private EC2 instance
resource "aws_instance" "private_ec2" {

  # AMI ID for EC2 instance
  ami = var.ami_id

  # EC2 instacne type
  instance_type = var.instance_type

  # Deploy EC2 into private subnet
  subnet_id = var.subnet_id

  # Attach security group
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

  # Attach IAM instance profile
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name

  # Prevent public IP assignment
  associate_public_ip_address = false

  # Tags for indentificaiton
  tags = merge(
    var.tags,
    {
      Name = var.ec2_name
    }
  )
}