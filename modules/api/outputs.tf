output "id" {
  value       = aws_apigatewayv2_api.api.id
  description = "ID of the created gateway API"
}

output "api_endpoint" {
  value       = aws_apigatewayv2_api.api.api_endpoint
  description = "url of the created gateway API"
}