terraform {
  backend "s3" {}
}

provider "aws" {
  region = "${var.aws_region}"
}

module "test" {
  source = "../modules/vpc"
  
  cidr = "10.0.0.0/24"
  tags = "${var.tags}"
}
