terraform {
  backend "s3" {}
}

provider "aws" {
    region = "${var.aws_region}"
}

resource "aws_vpc" "example_vpc" {
  cidr_block = "${var.cidr}"
  tags = "${merge(var.tags, map("Name", "App-VPC-${terraform.workspace}"))}"
}