variable "iam_user" {
  description = "IAM user name"
  type        = string
}

variable "bucket_arn" {
  description = "This is the value for s3 bucket_arn"
  type        = string
}

variable "object_arn" {
  description = "This is the value for s3 object_arn"
  type        = string
}

variable "tags" {
  description = "Map of tags for the bucket"
  type        = map(string)
}