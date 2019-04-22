terragrunt = {
  terraform {
    source = "../../../modules//app"
  }
  
  include {
    path = "${find_in_parent_folders()}"
  }
}