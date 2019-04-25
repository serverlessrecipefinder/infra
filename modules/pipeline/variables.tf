variable "aws_region" {
  description = "The AWS region to deploy to (e.g. us-east-1)"
}

variable "name" {
  description = "The name of the AWS pipeline"
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

variable "branch" {
  type        = "string"
  description = "The branch to checkout from"
  default = "master"
}

variable "buildcode_target_staging" {
  type        = "string"
  description = "The target codebuild project for staging"
}

variable "buildcode_target_production" {
  type        = "string"
  description = "The target codebuild project for production"
}

