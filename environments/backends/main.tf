terraform {
  backend "s3" {
      bucket="recipefinder-tfstate"
      key="terraform/terraform_backends.tfstate"
      region="eu-west-2"
      dynamodb_table = "recipefinder-tfstate"
  }
}

provider "aws" {
  region = "eu-west-2"
}

module "backends" {
  source="../../modules/backends"
}
