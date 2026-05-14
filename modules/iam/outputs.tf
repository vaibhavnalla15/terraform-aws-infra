# Outputs IAM user name for reference outside the module
output "iam_user_name" {
  value = aws_iam_user.tf_iam_user.name
}

# Outputs IAM policy ARN for external usage/debugging
output "iam_policy_arn" {
  value = aws_iam_policy.s3_policy.arn
}