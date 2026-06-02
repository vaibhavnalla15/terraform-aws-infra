# Output parameter name
output "parameter_name" {
  value = aws_ssm_parameter.db_password.name
}