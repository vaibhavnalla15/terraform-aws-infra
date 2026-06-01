# Local values derived from current Terraform workspace
locals {

  # Current active workspace name
  environment = terraform.workspace
}