resource "aws_s3_bucket" "artefacts" {
  bucket = "recipe-finder-artefact"
  acl    = "private"
  tags = "${var.tags}"
}