# PowerShell script to destroy all Terraform infrastructure with S3 cleanup
Write-Host "Starting Terraform destroy process with S3 cleanup..." -ForegroundColor Yellow

# Change to the project directory
Set-Location "C:\github\aws-etl-poc-extended"

# Get the bucket name from Terraform output or use the default
$bucketName = "my-etl-poc-nr-2025-xyz"

Write-Host "Emptying S3 bucket: $bucketName" -ForegroundColor Cyan

# Empty the S3 bucket first
aws s3 rm s3://$bucketName --recursive

if ($LASTEXITCODE -eq 0) {
    Write-Host "S3 bucket emptied successfully!" -ForegroundColor Green
} else {
    Write-Host "Failed to empty S3 bucket. Continuing with destroy..." -ForegroundColor Yellow
}

# Run terraform destroy with auto-approve
Write-Host "Running Terraform destroy..." -ForegroundColor Cyan
terraform destroy -auto-approve -var="s3_bucket_name=$bucketName"

if ($LASTEXITCODE -eq 0) {
    Write-Host "Terraform destroy completed successfully!" -ForegroundColor Green
} else {
    Write-Host "Terraform destroy failed with exit code: $LASTEXITCODE" -ForegroundColor Red
}