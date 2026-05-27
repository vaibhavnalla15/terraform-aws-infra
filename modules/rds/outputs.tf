# Outputs RDS endpoint for application connectivity
output "rds_endpoint" {
  value = aws_db_instance.mysql_db.endpoint
}

# Outputs RDS instance ID
output "rds_instance_id" {
  value = aws_db_instance.mysql_db.id
}

# Outputs RDS security group ID
output "rds_security_group_id" {
  value = aws_security_group.rds_sg.id
}