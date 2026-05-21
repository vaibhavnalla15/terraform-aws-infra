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