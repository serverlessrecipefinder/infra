resource "aws_s3_bucket" "terraform_state" {
  bucket = "${var.bucket}"

  versioning {
    enabled = true
  }

  lifecycle {
    prevent_destroy = false
  }
  
}

resource "aws_dynamodb_table" "terraform_state_lock" {
  name           = "${var.dynamodb_table}"
  hash_key       = "LockID"
  billing_mode   = "PAY_PER_REQUEST"

  attribute {
    name = "LockID"
    type = "S"
  }
}