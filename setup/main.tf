provider "aws" {
  region  = "${var.region}"
}

module "backend" {
  source = "../modules/backends/"

  bucket         = "${var.bucket}"
  dynamodb_table = "${var.dynamodb_table}"
}
