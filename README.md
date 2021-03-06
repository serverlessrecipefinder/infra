# Infrastructure

## Prerequisites

- Terraform
- Terragrunt

## Bootstrap

Terragrunt handles the creation of the backend if it doesn't already exist. This will be created **if necessary** when running the `init` command.

The infrastructure is managed via AWS CodePipeline, and the initial pipeline is created by creating the globals module.

1) Run the infrastructure bootstrap. You will be prompted to provide an OAuth token for Github via the command line for this step.

```
cd live/boostrap/
terragrunt init --terragrunt-non-interactive
terragrunt plan
terragrunt apply
```
This will create an OAuth SSM token used in the later pipeline stages.

2) Run the globals module to create the global resources. This creates code pipeline resources that will build this module on changes to this repository.

```
cd live/globals/
terragrunt init --terragrunt-non-interactive
terragrunt plan
terragrunt apply
```

Changes to globals should now be made by merging to master.

## Local Development

TODO: Workspaces.

## Layout

* *live/* - Configuration files for various environments.
* *modules/* - Terraform modules.

# Local Setup

Set `export AWS_PROFILE=<profile_name>` to select a specific profile.
