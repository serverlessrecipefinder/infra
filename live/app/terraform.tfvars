# File storing common Terragrunt & Terraform configuration, referenced by child modules.

# Common Terragrunt configuration.
terragrunt = {
  include {
    path = "${find_in_parent_folders()}"
  }

  terraform {
    source = "../../modules//app"

    extra_arguments "conditional_vars" {
      commands  = ["${get_terraform_commands_that_need_locking()}"]

      required_var_files = [
        "${get_tfvars_dir()}/app.tfvars",
        "${get_tfvars_dir()}/${get_env("RF_TF_ENV", "staging")}.tfvars"
      ]
    }
  }
}