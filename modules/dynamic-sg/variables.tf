# Security group name
variable "security_group_name" {
  type = string
}

# VPC ID where SG will be created
variable "vpc_id" {
  type = string
}

# Dynamic ingress rules list
variable "ingress_rule" {
  
  type = list(object({
    
    # Starting port
    from_port = number 

    # Ending port
    to_port = number

    # Protocol type
    protocol = string

    # Allowed CIDR blocks
    cidr_blocks = list(string)

    # Rule description
    description = string
  }))
}   

# Common tags
variable "tags" {
  type = map(string)
}