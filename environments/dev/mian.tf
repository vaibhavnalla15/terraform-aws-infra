# Calling S3 Module
module "tf_bucket" {
  source = "../../modules/s3"

  bucket_name = var.bucket_name
  tags = var.tags
}