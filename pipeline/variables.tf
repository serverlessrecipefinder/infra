variable "aws_region" {
  description = "The AWS region to deploy to (e.g. us-east-1)"
}

variable "tags" {
  type        = "map"
  description = "Tags to apply to resources in the module"
}

variable "github_oauth_token" {
  description = "OAuth token for GitHub"
}