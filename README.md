# Infrastructure

## Bootstrap

The bootstrap assumes this is being created into a completely fresh environment with no prior existing resources or backend.

1. Create the backend s3 bucket and lock table.
`./setup.sh`

2. Create a GitHub personal token to use in the pipeline. (Not a long term solution.)

3. Ensure this project is pushed to the target repository.

4. Create the Terraform CD pipeline, passing in the token as an input.
```
cd globals &&
terraform init -backend-config=../backend.tfvars
terraform apply -auto-approve -var "github_oauth_token=$OAUTH_TOKEN"
```
