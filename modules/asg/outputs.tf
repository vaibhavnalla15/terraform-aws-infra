# Outputs Auto Scaling Group name
output "asg_name" {
  value = aws_autoscaling_group.tf_asg.name
}

# Outputs Launch Template ID
output "launch_template_id" {
  value = aws_launch_template.tf_launch_temp.id
}