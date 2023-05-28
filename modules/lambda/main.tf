resource "aws_lambda_function" "main" {
  function_name = var.lambda_function_name
  role          = var.iam_for_lambda_arn
  package_type  = "Image"

  image_uri = "${var.repository_url}:latest"

  timeout = 60

  environment {
    variables = {
      BUCKET_NAME = var.bucket_name
    }
  }
}
