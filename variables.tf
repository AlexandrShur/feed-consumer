variable "aws_region" {
  description = "AWS region where infrastructure should be created"
}

variable "s3_id" {
  description = "S3 ID which will be used for bucket creation"
}

variable "client_id" {
  description = "Google identity provider client ID"
}

variable "client_secret" {
  description = "Google identity provider client secret"
}

variable "auth_domain" {
  description = "Domain prefix for created authorization server"
}

variable "account_id" {
  description = "AWS account ID"
}