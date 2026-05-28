# S3 Module Outputs
output "s3_bucket_name" {
  description = "The name of the bucket"
  value       = module.tf_bucket.s3_bucket_name
}

output "bucket_arn" {
  description = "The ARN of the bucket"
  value       = module.tf_bucket.bucket_arn
}

# Outputs VPC ID from VPC module
output "vpc_id" {
  value = module.vpc.vpc_id
}

# Outputs public subnet IDs from VPC module
output "public_subnet_ids" {
  value = module.vpc.public_subnet_ids
}

# Outputs private subnet IDs from VPC module
output "private_subnet_ids" {
  value = module.vpc.private_subnet_ids
}

# EC2 Modules Outputs
# Outputs EC2 instance ID
output "instacne_id" {
  value = module.ec2.instacne_id
}

# Output private IP address of EC2 instance
output "private_ip" {
  value = module.ec2.private_ip
}

# Ouputs security group ID
output "security_group_id" {
  value = module.ec2.security_group_id
}

# # RDS Module's Outputs
# output "rds_endpoint" {
#   value = module.rds.rds_endpoint
# }

# # Outputs RDS instance ID
# output "rds_instance_id" {
#   value = module.rds.rds_instance_id
# }

# # Outputs RDS security group ID
# output "rds_security_group_id" {
#   value = module.rds.rds_security_group_id
# }

# ALB Module Outputs
output "alb_dns_name" {
  value = module.alb.alb_dns_name
}

output "asg_name" {
  value = module.asg.asg_name
}