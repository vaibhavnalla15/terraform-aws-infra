# Calling S3 Module
module "tf_bucket" {
  source = "../../modules/s3"

  bucket_name = var.bucket_name
  tags = var.tags
}

# Creates IAM resources for secure S3 access
module "iam" {
  source = "../../modules/iam"

  # IAM username
  iam_user = var.iam_user

  # Bucket ARN from S3 module output
  bucket_arn = module.tf_bucket.bucket_arn

  # Object ARN from S3 module output
  object_arn = module.tf_bucket.object_arn

  # Common tags
  tags = {
    Environment = "dev"
    Project     = "terraform-aws-infra"
  }
}