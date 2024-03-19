resource "aws_lambda_function" "source_process" {
  filename      = "sources/lambda/source_process.zip"
  function_name = "source_process"
  role          = "${var.lambda_iam_role_arn}"
  handler       = "source_process.lambda_handler"
  timeout       = 900

  # The filebase64sha256() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
  # source_code_hash = "${base64sha256(file("lambda_function_payload.zip"))}"
  source_code_hash = filebase64sha256("sources/lambda/source_process.zip")

  runtime = "python3.8"

  environment {
    variables = {
      bucket = "${var.s3_id}"
    }
  }
}

resource "aws_cloudwatch_event_rule" "source_process_scheduler" {
  name                = "source_process_scheduler"
  description         = "Exucutes source procession script every 20 minutes"
  schedule_expression = "rate(20 minutes)"
}

resource "aws_lambda_permission" "event_lambda_process" {
  statement_id  = "AllowRuleEventsToExecuteLambda"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.source_process.function_name
  principal     = "events.amazonaws.com"
  source_arn    = "arn:aws:events:${var.aws_region}:${var.account_id}:rule/source_process_scheduler"
}

resource "aws_cloudwatch_event_target" "source_process_target" {
  rule = aws_cloudwatch_event_rule.source_process_scheduler.name
  arn  = "arn:aws:lambda:${var.aws_region}:${var.account_id}:function:source_process"
}