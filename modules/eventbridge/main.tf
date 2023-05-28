resource "aws_cloudwatch_event_rule" "every-month-run-lambda" {
  name                = "every-month-run-lambda"
  schedule_expression = "cron(0 0 1 * ? *)"
}

resource "aws_cloudwatch_event_target" "run_lambda_every_month" {
  rule      = aws_cloudwatch_event_rule.every-month-run-lambda.name
  target_id = "run_lambda_function"
  arn       = var.lambda_arn
}
