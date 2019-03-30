terraform {
  backend "s3" {
    key = "terraform_setup.tfstate"
  }
}
