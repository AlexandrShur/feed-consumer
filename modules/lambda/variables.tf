variable "s3_id" {
  description = "The created s3 bukcket ID to work with"
}

variable "api_id" {
  description = "gateway API ID"
}

variable "s3_read_policy_arn" {
  description = "arn of the policy for read access to the s3 bucket"
}

variable "s3_write_policy_arn" {
  description = "arn of the policy for write access to the s3 bucket"
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