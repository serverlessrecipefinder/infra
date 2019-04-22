# Infrastructure

## Prerequisites

- Terraform
- Terragrunt

## Bootstrap

Terragrunt handles the creation of the backend if it doesn't already exist. This will be created **if necessary** when running the `init` command.

The infrastructure is managed via AWS CodePipeline, and the initial pipeline is created by creating the globals module.

You will be prompted to provide an OAuth token for Github via the command line for this step.

```
cd live/boostrap/
terraform init --terragrunt-non-interactive
terraform plan
terraform apply
```

## Layout

* *live/* - Configuration files for various environments.
* *modules/* - Terraform modules.
