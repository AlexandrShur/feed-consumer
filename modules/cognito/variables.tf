variable "client_id" {
  description = "Identity provider cleint identifier"
}

variable "client_secret" {
  description = "Identity provider cleint secret"
}

variable "auth_domain" {
  description = "Authenticator identity service domain prefix"
}

variable "callback_url" {
  description = "Allowed urls which could be redirected to after authentication process"
}

variable "resource_server_url" {
  description = "API's url which works with identity provider"
}

variable "resource_server_id" {
  description = "API's ID which would be integrated with"
}