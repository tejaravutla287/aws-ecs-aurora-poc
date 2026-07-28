# AWS ECS Fargate + Aurora POC

## Deploy DEV

terraform init

terraform plan -var-file=dev.tfvars

terraform apply -var-file=dev.tfvars

## Deploy STAGING

terraform plan -var-file=staging.tfvars

terraform apply -var-file=staging.tfvars
