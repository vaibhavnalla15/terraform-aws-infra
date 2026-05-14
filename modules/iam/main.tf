# Creating IAM User
resource "aws_iam_user" "tf_iam_user" {
  name = var.iam_user
  tags = var.tags
}

# Generates IAM policy JSON dynamically for secure S3 bucket and object access
data "aws_iam_policy_document" "s3_policy" {

  statement {
    effect = "Allow"

    actions = [
      "s3:ListBucket"
    ]

    resources = [
      var.bucket_arn
    ]
  }

  statement {
    effect = "Allow"

    actions = [
      "s3:GetObject",
      "s3:PutObject"
    ]

    resources = [
      var.object_arn
    ]
  }

}

# Creates an actual AWS IAM policy using the generated policy JSON
resource "aws_iam_policy" "s3_policy" {

  # Name of the IAM policy
  name = "${var.iam_user}-s3-policy"

  # Uses dynamically generated IAM policy JSON
  policy = data.aws_iam_policy_document.s3_policy.json

  # Tags for resource identification and management
  tags = var.tags
}

# Attaches the S3 access policy to the IAM user
resource "aws_iam_user_policy_attachment" "s3_policy_attach" {

  # IAM user created earlier
  user = aws_iam_user.tf_iam_user.name

  # IAM policy ARN created earlier
  policy_arn = aws_iam_policy.s3_policy.arn
}