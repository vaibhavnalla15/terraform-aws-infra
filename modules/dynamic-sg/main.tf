# Dynamic Security Group
resource "aws_security_group" "dynamic_sg" {

  # Security group name
  name = var.security_group_name

  # VPC association
  vpc_id = var.vpc_id

  # Dynamically create ingress rules
  dynamic "ingress" {

    # Loop through ingress rules list
    for_each = var.ingress_rule

    content {

      # Starting port
      from_port = ingress.value.from_port

      # Ending port
      to_port = ingress.value.to_port

      # Protocol type
      protocol = ingress.value.protocol

      # Allowed CIDR ranges
      cidr_blocks = ingress.value.cidr_blocks

      # Rule description
      description = ingress.value.description
    }
  }

  # Outbound traffic rule
  egress {

    from_port = 0
    to_port   = 0
    protocol  = "-1"

    cidr_blocks = ["0.0.0.0/0"]
  }

  # Resource tags
  tags = var.tags
}