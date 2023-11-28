variable "aws_account_id" {
  description = "The AWS Account ID"
  type        = string
  default = "432702836969"
}

variable "repository_name" {
  description = "The username and repository"
  type        = string
  default = "jordanhoare/feast-aws"
}

variable "thumbprint_list" {
  description = "(Optional) A list of server certificate thumbprints for the OpenID Connect (OIDC) identity provider's server certificate(s)."
  type        = list(string)
  default = ["a031c46782e6e6c662c2c87c76da9aa62ccabd8e"]
}