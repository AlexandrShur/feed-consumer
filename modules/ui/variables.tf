variable "aws_region" {
  description = "aws region where infrastructure should be created"
}

variable "provider_domain_id" {
  description = "Domain ID which will be used for s3 bucket and site access"
}

variable "s3_id" {
  description = "The ID of the s3 bucket"
}

variable "domain_url" {
  description = "The URL of the website"
}

variable "client_id" {
  description = "ID of the created client"
}

variable "client_secret" {
  description = "Secret of the created client"
}

variable "user_pool_id" {
  description = "The created cognito user pool ID"
}

variable "api_endpoint" {
  description = "Requests API path"
}
