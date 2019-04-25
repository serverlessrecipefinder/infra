terragrunt = {
  remote_state {
    backend = "s3"
    config {
      bucket         = "recipe-finder-tf-state"
      key            = "${path_relative_to_include()}/terraform.tfstate"
      region         = "eu-west-2"
      encrypt        = true
      dynamodb_table = "recipe-finder-tf-lock"

      s3_bucket_tags {
        Project = "recipe-finder"
      }

      dynamodb_table_tags {
        Project = "recipe-finder"
      }
    }
  }
}