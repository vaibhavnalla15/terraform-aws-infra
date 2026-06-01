# Outputs EC2 instance ID
output "instacne_id" {
  value = aws_instance.private_ec2.id
}

# Output private IP address of EC2 instance
output "private_ip" {
  value = aws_instance.private_ec2.private_ip
}

# Ouputs security group ID
output "security_group_id" {
  value = aws_security_group.ec2_sg.id
}

# Outputs IAM instance profile name
output "instance_profile_name" {
  value = aws_iam_instance_profile.ec2_profile.name
}

# Outputs dynamically discovered Amazon Linux AMI ID
output "ami_id" {
  value = data.aws_ami.amazon_linux.id
}