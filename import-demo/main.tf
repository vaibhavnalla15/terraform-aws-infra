# Importing Existing manually-created S3 Bucket
resource "aws_s3_bucket" "manual_bucket" {

  # Existing Bucket name
  bucket = "tf-saul-07"
}