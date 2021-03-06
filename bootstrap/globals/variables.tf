variable "aws_region" {
  description = "The AWS region to deploy to (e.g. us-east-1)"
}

variable "tags" {
  type        = "map"
  description = "Tags to apply to all resources in the module"
}

variable "github_org" {
  type        = "string"
  description = "The github organisation"
}

variable "repo" {
  type        = "string"
  description = "The github repository acting as a source"
}

variable "github_oauth_token" {
  type        = "string"
  description = "An OAuth token providing Github access"
}

variable "branch" {
  type        = "string"
  description = "The branch to checkout from"
}
