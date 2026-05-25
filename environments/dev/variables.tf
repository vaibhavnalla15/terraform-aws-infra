# S3 module variables
variable "bucket_name" {
  description = "The globally unique name for the S3 bucket"
  type        = string
}

variable "tags" {
  description = "Map of tags for the bucket"
  type        = map(string)
}

# IAM module module variables
variable "iam_user" {
  description = "IAM user name"
  type        = string
}

# VPC module variables
variable "vpc-cidr" {
  description = "This is the value for VPC CIDR"
  type        = string
}

variable "public-subnet-cidr" {
  description = "List of public subnet cidrs"
  type        = list(string)
}

variable "private-subnet-cidr" {
  description = "List of private subnet cidrs"
  type        = list(string)
}

variable "azs" {
  description = "List of availability zones"
  type        = list(string)
}

variable "vpc-tags" {
  description = "Tags for the projects"
  type        = map(string)
}

variable "environment" {
  type = string
}

# EC2 Module variables
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

variable "ec2_tags" {
  description = "Map of tags for the bucket"
  type        = map(string)
}