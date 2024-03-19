resource "aws_cognito_user_pool" "pool" {
  name = "rss"
}

resource "aws_cognito_identity_provider" "provider" {
  user_pool_id  = aws_cognito_user_pool.pool.id
  provider_name = "Google"
  provider_type = "Google"

  provider_details = {
    authorize_scopes = "email"
    client_id        = "${var.client_id}"
    client_secret    = "${var.client_secret}"
  }

  attribute_mapping = {
    email    = "email"
    username = "sub"
  }
}

resource "aws_cognito_user_pool_domain" "domain" {
  domain       = var.auth_domain
  user_pool_id = aws_cognito_user_pool.pool.id
}

resource "aws_cognito_user_pool_client" "client" {
  name 						           = "client"
  user_pool_id 				           = aws_cognito_user_pool.pool.id
  allowed_oauth_scopes		           = ["openid"]
  allowed_oauth_flows_user_pool_client = true
  enable_token_revocation              = true
  allowed_oauth_flows 		           = ["code"]
  callback_urls 			           = ["${var.callback_url}"]
  supported_identity_providers         = [aws_cognito_identity_provider.provider.provider_name]
  explicit_auth_flows                  = [
	  "ALLOW_CUSTOM_AUTH",
	  "ALLOW_REFRESH_TOKEN_AUTH",
	  "ALLOW_USER_SRP_AUTH"
  ]
  refresh_token_validity        = 30
  prevent_user_existence_errors = "ENABLED"
  generate_secret               = true
}

resource "aws_cognito_resource_server" "resource" {
  identifier = "${var.resource_server_url}"
  name       = "rss"

  scope {
    scope_name        = "openid"
    scope_description = "Main authorization scope"
  }

  user_pool_id = aws_cognito_user_pool.pool.id
}

resource "aws_apigatewayv2_authorizer" "authorizer" {
  api_id           = "${var.resource_server_id}"
  name             = "rss"
  authorizer_type  = "JWT"
  identity_sources = ["$request.header.Authorization"]
  enable_simple_responses = false

  jwt_configuration {
    audience = [aws_cognito_user_pool_client.client.id]
    issuer   = "https://${aws_cognito_user_pool.pool.endpoint}"
  }
}