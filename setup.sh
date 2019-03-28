# !bin/bash
#
# This script bootstraps the environment. It assume a completely empty environment and that
# no backend resources already exist.
#
set -x

# 1. Create a temporary working directory
TMP_DIR=$(mktemp -d)

# 2. Copy the infra project into the temp directory, but remove the backend config
cp -r . "$TMP_DIR"

# 3. Remove the backend config and setup the backend resources generating local state for them.
pushd $TMP_DIR
rm "setup/backend.tf"
terraform init setup
terraform apply -var-file=backend.tfvars -auto-approve setup
popd

# 4. Copy the generated state files back into the project.
cp "$TMP_DIR"/terraform.tfstate "$TMP_DIR"/terraform.tfstate.backup . 
rm -rf $TMP_DIR

# 5. Initialise again back in the project. The backend file exists here and Terraform will ask to migrate state.
terraform init -backend-config=backend.tfvars setup

# 6. Delete the local state files.
rm terraform.tfstate terraform.tfstate.backup

