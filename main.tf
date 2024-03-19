# Configure the AWS Provider
provider "aws" {
  region = "${var.aws_region}"
}

module "s3" {
  source = "./modules/s3"

  id = "${var.s3_id}"
}

module "cloudfront" {
  source = "./modules/cloudfront"

  s3_id                       = "${var.s3_id}"
  bucket_regional_domain_name = module.s3.bucket_regional_domain_name
}

module "ui" {
  source = "./modules/ui"

  aws_region          = "${var.aws_region}"
  provider_domain_id  = "${var.auth_domain}"
  s3_id               = "${var.s3_id}"
  domain_url          = module.cloudfront.distribution_url
  client_id           = module.cognito.client_id
  client_secret       = module.cognito.client_secret
  user_pool_id        = module.cognito.pool_id
  api_endpoint        = module.api.api_endpoint

  depends_on = [module.s3, module.cognito, module.api, module.cloudfront]
}

module "cognito" {
  source = "./modules/cognito"

  client_id           = "${var.client_id}"
  client_secret       = "${var.client_secret}"
  auth_domain         = "${var.auth_domain}"
  #callback_url        = module.s3.domain_url
  callback_url        = module.cloudfront.distribution_url
  resource_server_url = module.api.api_endpoint
  resource_server_id  = module.api.id

  depends_on = [module.s3, module.api, module.cloudfront]
}

module "api" {
  source = "./modules/api"
}

module "lambda" {
  source = "./modules/lambda"
  
  s3_id               = module.s3.id
  api_id              = module.api.id
  s3_write_policy_arn = module.s3.s3_write_policy_arn
  s3_read_policy_arn  = module.s3.s3_read_policy_arn
  authorizer_id       = module.cognito.authorizer_id
  account_id          = "${var.account_id}"
  aws_region          = "${var.aws_region}"
    
  depends_on = [module.s3, module.api, module.cognito]
}