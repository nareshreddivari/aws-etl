# File: destroy-poc.ps1
# Usage: Open PowerShell in the repo root and run: .\destroy-poc.ps1

# Step 1: Initialize Terraform
Write-Host "Initializing Terraform..."
terraform init -upgrade

# Step 2: Validate Terraform configuration
Write-Host "Validating Terraform..."
terraform validate

# Step 3: Destroy Terraform-managed infrastructure
Write-Host "Destroying all Terraform-managed resources..."
terraform destroy -auto-approve

Write-Host "✅ All resources destroyed!"
