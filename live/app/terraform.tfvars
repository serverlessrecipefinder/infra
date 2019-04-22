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
      profile        = "recipefinder"
      
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
      commands  = ["${get_terraform_commands_that_need_locking()}"]

      required_var_files = [
        "${get_tfvars_dir()}/${find_in_parent_folders("app.tfvars")}",
        "${get_tfvars_dir()}/env.tfvars"
      ]
    }
  }
}