# S3 bucket for Terraform remote state storage
resource "aws_s3_bucket" "tf_state" {

  # Globally unique bucket name
  bucket = var.bucket_name

  # Tags for indentification
  tags = var.bucket_tags
}

# Enable versioning for Terraform state protection
resource "aws_s3_bucket_versioning" "tf_state_versioning" {

  # Attach versioning to S3 bucket
  bucket = aws_s3_bucket.tf_state.id

  # Enble versioning
  versioning_configuration {
    status = "Enabled"
  }
}

# Enable server-side encryption for Terraform state security 
resource "aws_s3_bucket_server_side_encryption_configuration" "tf_state_encryption" {

  # Attach encryption configuration to bucket
  bucket = aws_s3_bucket.tf_state.id

  # Default encryption rule 
  rule {
    apply_server_side_encryption_by_default {

      # AES256 encryption
      sse_algorithm = "AES256"
    }
  }
}

# Block all public access to Terraform state bucket
resource "aws_s3_bucket_public_access_block" "tf_state_public_block" {

  # Attach public access block to bucket
  bucket = aws_s3_bucket.tf_state.id

  # Block public ACLs
  block_public_acls = true

  # Block public bucket policies
  block_public_policy = true

  # Ignore public ACLs
  ignore_public_acls = true

  # Restrict public bucket policies
  restrict_public_buckets = true
}