# Create Launch Template
resource "aws_launch_template" "tf_launch_temp" {
  # Launch template name
  name_prefix = "${var.environment}-launch-template"

  # AMI ID for EC2 instances
  image_id = var.ami_id

  # EC2 instance type
  instance_type = var.instance_type

  # Attach IAM instance profile
  iam_instance_profile {
    name = var.iam_instance_profile_name
  }

  # Disable public IP assignment
  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [var.security_group_id]
  }

  # Tag EC2 instances launched by ASG
  tag_specifications {

    # Resource type
    resource_type = "instance"

    # Tags for instances
    tags = merge(
      var.asg-tags,
      {
        Name = "${var.environment}-asg-instance"
      }
    )
  }

  # User data script to install and start Apache web server
  user_data = base64encode(file("${path.module}/user_data.sh"))
}

# Creates Auto Scaling Group (ASG)
resource "aws_autoscaling_group" "tf_asg" {
  # Auto Scaling Group name
  name = "${var.environment}-tf_asg"

  # Desired number of EC2 instances
  desired_capacity = var.desired_capacity

  # Minimum number of EC2 instances
  max_size = var.max_size

  # Maximum number of EC2 instances
  min_size = var.min_size

  # Deploy instances into private subnets
  vpc_zone_identifier = var.private_subnet_ids

  # Attach Target Group to ASG
  target_group_arns = [var.target_group_arn]

  # Use ELB health checks
  health_check_type = "ELB"

  # Wait time before health check
  health_check_grace_period = 300

  # Launch template configuration
  launch_template {
    # Launch template ID
    id = aws_launch_template.tf_launch_temp.id

    # Always use latest template version
    version = "$Latest"
  }

  # Tags for EC2 instances launched by ASG
  tag {

    key                 = "Name"
    value               = "${var.environment}-asg-instance"
    propagate_at_launch = true
  }
}