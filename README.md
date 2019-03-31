# Infrastructure

## Bootstrap

The bootstrap assumes this is being created into a completely fresh environment with no prior existing resources or backend.

1. Set your AWS profile if credentials aren't default. e.g.
`AWS_PROFILE=recipefinder`

2. Create the backend s3 bucket and lock table.
`./setup.sh`

3. Create a GitHub personal token to use in the pipeline. (Not a long term solution.)

4. Ensure this project is pushed to the target repository.

5. Create the Terraform CD pipeline, passing in the token as an input.
```
terraform init -backend-config=backend.tfvars globals
terraform apply -auto-approve -var "github_oauth_token=$OAUTH_TOKEN"
```

## Layout

* *setup/* - Module for initial project setup. Ran once at project initialisation.
* *globals/* - Module for global project configuration - resources that are independant of the application environment.
* *environment* - The application environment.
