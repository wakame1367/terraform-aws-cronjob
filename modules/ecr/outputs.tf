output "repository_url" {
  description = "The url of the ecr"
  value       = aws_ecr_repository.rust_lambda.repository_url
}

output "ecr_arn" {
  description = "The arn of the ecr"
  value       = aws_ecr_repository.rust_lambda.arn
}
