resource "aws_apigatewayv2_api" "api" {
  name                         = "rss"
  protocol_type                = "HTTP"
  route_selection_expression   = "$request.method $request.path"
  api_key_selection_expression = "$request.header.x-api-key"
  
  cors_configuration {
	allow_credentials = false
	allow_headers     = ["*"]
	allow_methods     = ["*"]
	allow_origins     = ["*"]
	expose_headers    = []
	max_age           = 0
  }
}

resource "aws_apigatewayv2_stage" "stage" {
  api_id      = aws_apigatewayv2_api.api.id
  name        = "$default"
  #invoke_url = aws_apigatewayv2_api.api.api_endpoint
  #invoke_url = "https://${aws_apigatewayv2_api.api.api_endpoint}"
  auto_deploy = true
  default_route_settings {
    data_trace_enabled = false
    detailed_metrics_enabled = false
    throttling_burst_limit = 100
    throttling_rate_limit = 100
  }
}
