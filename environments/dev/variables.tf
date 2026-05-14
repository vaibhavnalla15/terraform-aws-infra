variable "bucket_name" {
  description = "The globally unique name for the S3 bucket"
  type        = string
}

variable "tags" {
  description = "Map of tags for the bucket"
  type        = map(string)
}

variable "iam_user" {
  description = "IAM user name"
  type        = string
}
