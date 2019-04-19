# File storing common Terragrunt & Terraform configuration, referenced by child modules.

# Common Terragrunt configuration.
terragrunt = {
  remote_state {
    backend = "s3"
    config {
      bucket         = "recipe-finder-tfstate"
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

  terraform {
    extra_arguments "conditional_vars" {
      commands = [
        "apply",
        "plan",
        "import",
        "push",
        "refresh",
        "destroy"
      ]

      required_var_files = [
        "${get_parent_tfvars_dir()}/terraform.tfvars"
      ]
    }
  }
}

# Above Terragrunt confugration passes this same file as --var-file to all commands. The result is that
# all variables defined in this file are available in any child module that imports the above Terragrunt
# configuration.
aws_region = "eu-west-2"
tags = {
    Project = "recipe-finder"
    Environment = "dev"
}
