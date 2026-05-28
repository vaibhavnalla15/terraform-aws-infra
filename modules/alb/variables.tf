variable "vpc_id" {
  type = string
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "target_port" {
  type = number
}

variable "environment" {
  type = string
}

variable "alb_tags" {
  type = map(string)
}