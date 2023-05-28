resource "aws_ecr_repository" "rust_lambda" {
  name = var.repo_name
}

