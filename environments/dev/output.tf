output "s3_bucket_name" {
  description = "The name of the bucket"
  value       = module.tf_bucket.s3_bucket_name
}

output "bucket_arn" {
  description = "The ARN of the bucket"
  value       = module.tf_bucket.bucket_arn
}