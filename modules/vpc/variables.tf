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

variable "tags" {
  description = "Tags for the projects"
  type        = map(string)
}

variable "environment" {
  type = string
}