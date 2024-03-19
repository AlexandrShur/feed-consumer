output "client_id" {
  value       = aws_cognito_user_pool_client.client.id
  description = "ID of the created identity client"
}

output "client_secret" {
  value       = aws_cognito_user_pool_client.client.client_secret
  description = "Secret of the created identity client"
}

output "pool_id" {
  value       = aws_cognito_user_pool.pool.id
  description = "Created user pool ID"
}

output "authorizer_id" {
  value       = aws_apigatewayv2_authorizer.authorizer.id
  description = "Returns authorizer ID needed for API integration"
}

