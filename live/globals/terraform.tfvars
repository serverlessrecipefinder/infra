terragrunt = {
  include {
    path = "${find_in_parent_folders()}"
  }

  terraform {

        source = "../../modules//pipeline"
    extra_arguments "conditional_vars" {
      commands  = ["${get_terraform_commands_that_need_locking()}"]

      required_var_files = [
          "${get_tfvars_dir()}/bootstrap.tfvars"
      ]
    }
  }
}
