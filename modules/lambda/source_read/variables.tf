variable "s3_id" {
  description = "The created s3 bukcket ID to work with"
}

variable "api_id" {
  description = "gateway API ID"
}

variable "authorizer_id" {
  description = "Cognito authorizer ID needed for API integration"
}

variable "aws_region" {
  description = "aws region neede to grant API permission to execute lambda"
}

variable "account_id" {
  description = "AWS account ID"
}

variable "lambda_iam_role_arn" {
  description = "iam role which need to be assigned to the lambda"
}
