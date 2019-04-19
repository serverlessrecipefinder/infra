terraform {
  backend "s3" {}
}

provider "aws" {
  region = "${var.aws_region}"
}

module "pipeline" {
  source = "../modules/pipeline"
  tags = "${var.tags}"
  github_org = "serverlessrecipefinder"
  repo = "infra"
  github_oauth_token = "${var.github_oauth_token}"
  branch = "master"
}
