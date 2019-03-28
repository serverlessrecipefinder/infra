resource "aws_s3_bucket" "terraform_state" {
  bucket = "recipefinder-tfstate"

  versioning {
    enabled = true
  }

  lifecycle {
    prevent_destroy = false
  }
}

resource "aws_dynamodb_table" "terraform_state_lock" {
  name           = "recipefinder-tfstate"
  hash_key       = "LockID"
  billing_mode   = "PAY_PER_REQUEST"

  attribute {
    name = "LockID"
    type = "S"
  }
}