resource "aws_cloudwatch_event_rule" "example" {
  name                = "example"
  schedule_expression = "cron(0 0 * * ? *)"
}

resource "aws_cloudwatch_event_target" "example" {
  rule     = aws_cloudwatch_event_rule.example.name
  arn      = aws_lambda_function.example.arn
  input    = "{}"
  role_arn = aws_iam_role.example.arn
}

resource "aws_lambda_permission" "example" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.example.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.example.arn
}
