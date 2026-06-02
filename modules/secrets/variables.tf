# Database password to store in SSH
variable "db_password" {
  type      = string
  sensitive = true
}

# Environment name
variable "environment" {
  type = string
}

# Common tags
variable "tags" {
  type = map(string)
}