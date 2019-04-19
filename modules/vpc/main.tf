resource "aws_vpc" "example_vpc" {
  cidr_block = "${var.cidr}"
  tags = "${var.tags}"
}