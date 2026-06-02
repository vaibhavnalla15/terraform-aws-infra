# Store database password securely in SSM Parameter Store
resource "aws_ssm_parameter" "db_password" {

  # Parameter name
  name = "/${var.environment}/database/password"

  # Secure encrypted parameter
  type = "SecureString"

  # Secrete Value
  value = var.db_password

  # Resource tags
  tags = merge(
    var.tags,
    {
      name = "${var.environment}-db-password"
    }
  )
}   