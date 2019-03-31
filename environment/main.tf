terraform {
  backend "s3" {
    key = "terraform_env.tfstate"
  }
}

resource "aws_dynamodb_table" "example-table" {
  name           = "my-example-table"
  hash_key       = "LockID"
  billing_mode   = "PAY_PER_REQUEST"

  attribute {
    name = "LockID"
    type = "S"
  }
}