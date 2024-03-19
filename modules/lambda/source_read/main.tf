resource "aws_lambda_function" "source_read" {
  filename      = "sources/lambda/source_read.zip"
  function_name = "source_read"
  role          = "${var.lambda_iam_role_arn}"
  handler       = "source_read.lambda_handler"
  timeout       = 15

  # The filebase64sha256() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
  # source_code_hash = "${base64sha256(file("lambda_function_payload.zip"))}"
  source_code_hash = filebase64sha256("sources/lambda/source_read.zip")

  runtime = "python3.8"

  environment {
    variables = {
      bucket = "${var.s3_id}"
    }
  }
}

resource "aws_apigatewayv2_integration" "source_read_integration" {
  api_id           = "${var.api_id}"
  integration_type = "AWS_PROXY"
  
  timeout_milliseconds      = 30000
  connection_type           = "INTERNET"
  description               = "Read stored sources from s3 bucket."
  integration_method        = "POST"
  integration_uri           = aws_lambda_function.source_read.invoke_arn
  payload_format_version    = "2.0"
}

resource "aws_apigatewayv2_route" "get_source_read" {
  api_id               = "${var.api_id}"
  route_key            = "GET /rss"
  authorization_type   = "JWT"
  authorizer_id        = "${var.authorizer_id}"
  target               = "integrations/${aws_apigatewayv2_integration.source_read_integration.id}"
  authorization_scopes = ["openid"]
}
 
resource "aws_lambda_permission" "api_lambda_read" {
  statement_id  = "AllowReadExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.source_read.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "arn:aws:execute-api:${var.aws_region}:${var.account_id}:${var.api_id}/*/*/rss"
}