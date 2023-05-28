output "iam_for_lambda" {
  description = "The arn of the aws_iam_role"
  value       = aws_iam_role.iam_for_lambda.arn
}
