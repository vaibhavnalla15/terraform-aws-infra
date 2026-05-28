# Outputs public DNS name of ALB
output "alb_dns_name" {
  value = aws_alb.tf_alb.dns_name
}

# Outputs Target Group ARN
output "target_group_arn" {
  value = aws_lb_target_group.app_tg.arn
}

# Outputs ALB Security Group ID
output "alb_security_group_id" {
  value = aws_security_group.alb_sg.id
}