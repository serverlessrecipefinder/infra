resource "aws_vpc" "example_vpc" {
  
  cidr_block = "${var.cidr}"
  tags = "${merge(var.tags, map("Name", "ExampleVPC-${terraform.workspace}"))}"
}