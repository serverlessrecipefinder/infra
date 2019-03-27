# Infrastructure

## Initialisation

1. Create the initial state buckets.

`cd <root>/modules/backends/` and run `terraform init && terraform apply`

2. Import the state into the buckets created in #1, migrating the state for the backend buckets into their own buckets. 

```
cd <root>/environments/backends
terraform import module.backends.aws_s3_bucket.terraform_state recipefinder-tfstate
terraform import module.backends.aws_dynamodb_table.terraform_state_lock recipefinder-tfstate
```

3. Running a `terraform plan` should cause no changes.

4. Run the globals to create the CI/CD pipeline.