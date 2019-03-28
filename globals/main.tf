locals {
  project = "recipefinder"
  region = "eu-west-2"
  tags = {
    Project = "${local.project}"
    Environment = "dev"
  }
}
provider "aws" {
  region = "eu-west-2"
}
module "common" {
  source = "../../common"
}
module "pipeline" {
  source="../../modules/pipeline"
  tags = "${local.tags}"
  prefix = "${local.project}"
  github_org = "serverlessrecipefinder"
  repo = "infra"
  github_oauth_token = "${var.github_oauth_token}"
  branch = "master"
}