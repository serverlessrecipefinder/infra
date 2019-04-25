terraform {
  backend "s3" {}
}

provider "aws" {
    region = "${var.aws_region}"
}
resource "aws_ssm_parameter" "github_oauth_token" {
  name  = "github_oauth_token"
  type  = "SecureString"
  value = "${var.github_oauth_token}"
}