# S3 bucket name for Terraform remote state
variable "bucket_name" {
  type = string
}

# Environment name
variable "environment" {
  type = string
}

# Common tags
variable "bucket_tags" {
  type = map(string)
}