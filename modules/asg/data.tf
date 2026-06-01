# Fetch latest Amazon Linux 2023 AMI
data "aws_ami" "amazon_linux" {

  # Get most recent AMI
  most_recent = true

  # Official Amazon owner account
  owners = ["amazon"]

  # Filter AMI by name pattern
  filter {
    name = "name"

    values = ["al2023-ami-*-x86_64"]
  }

  # Filter virtualization type
  filter {
    name = "virtualization-type"

    values = ["hvm"]
  }
}