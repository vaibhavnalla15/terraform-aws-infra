output "s3_bucket_name" {
  description = "The name of the bucket"
  value       = aws_s3_bucket.tf_bucket.id
}

output "bucket_arn" {
  description = "The ARN of the bucket"
  value       = aws_s3_bucket.tf_bucket.arn
}

output "object_arn" {
  description = "Outputs object ARN pattern for object-level S3 permissions"
  value       = "${aws_s3_bucket.tf_bucket.arn}/*"
}