# File: deploy-poc.ps1
# Usage: Open PowerShell in the repo root and run: .\deploy-poc.ps1

# Step 0: Ensure we can use .NET zip functionality
Add-Type -AssemblyName System.IO.Compression.FileSystem

# Step 1: Zip Lambda function
$lambdaDir = Join-Path $PSScriptRoot "lambda"
$zipFile = Join-Path $lambdaDir "lambda_function.zip"

if (-Not (Test-Path $zipFile)) {
    Write-Host "Zipping Lambda function..."
    [System.IO.Compression.ZipFile]::CreateFromDirectory($lambdaDir, $zipFile)
    Write-Host "✅ Lambda zipped to $zipFile"
} else {
    Write-Host "Lambda zip already exists: $zipFile"
}

# Step 2: Initialize Terraform
Write-Host "Initializing Terraform..."
terraform init -upgrade

# Step 3: Validate Terraform configuration
Write-Host "Validating Terraform..."
terraform validate

# Step 4: Plan Terraform
Write-Host "Planning Terraform deployment..."
terraform plan

# Step 5: Apply Terraform
Write-Host "Applying Terraform deployment..."
terraform apply -auto-approve

Write-Host "✅ Deployment complete!"
