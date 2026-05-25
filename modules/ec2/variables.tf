variable "ami_id" {
  description = "Official AMI ID from AWS"
  type        = string
}

variable "instance_type" {
  description = "Select appropiate instance_type as per use cases"
  type        = string
}

variable "ec2_name" {
  description = "Enter name of the EC2 Instance"
  type        = string
}

variable "allowed_ssh_cidr" {
  description = " SSH cidr to connect EC2 Instance"
  type        = list(string)
}

variable "vpc_id" {
  description = "Create a private VPC to connet EC2 Instance"
  type        = string
}

variable "subnet_id" {
  description = "Private subnet id to place EC2 instance"
  type        = string
}

variable "environment" {
  type = string
}

variable "tags" {
  description = "Map of tags for the bucket"
  type        = map(string)
}

# Existing S3 IAM policy ARN
variable "s3_policy_arn" {
  type = string
}