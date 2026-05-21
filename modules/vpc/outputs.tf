# Outputs VPC ID for use in other modules
output "vpc_id" {
  value = aws_vpc.main.id
}

# Outputs public subnet IDs
output "public_subnet_ids" {
  value = aws_subnet.public-subnet[*].id
}

# Outputs private subnet IDs
output "private_subnet_ids" {
  value = aws_subnet.private-subnet[*].id
}

