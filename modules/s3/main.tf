# S3 Bucket Creation
resource "aws_s3_bucket" "tf_bucket" {
  bucket = var.bucket_name
  tags   = var.tags
}

# S3 Bucket enabling versioning
resource "aws_s3_bucket_versioning" "versioning_example" {
  bucket = aws_s3_bucket.tf_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# S3 Bucket lifecycle policy with delete after 30 Days
resource "aws_s3_bucket_lifecycle_configuration" "example_lifecycle" {
  bucket = aws_s3_bucket.tf_bucket.id

  rule {
    id     = "delete-after-30-days"
    status = "Enabled"

    # Leave filter empty to apply to all objects in the bucket
    filter {}

    expiration {
      days = 30
    }
  }
}

# S3 Bucket Block Public Access
resource "aws_s3_bucket_public_access_block" "block_public_acc" {
  bucket = aws_s3_bucket.tf_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}