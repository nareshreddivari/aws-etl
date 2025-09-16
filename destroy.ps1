# PowerShell script to destroy all Terraform infrastructure
Write-Host "Starting Terraform destroy process..." -ForegroundColor Yellow

# Change to the project directory
Set-Location "C:\github\aws-etl-poc-extended"

# Run terraform destroy with auto-approve and the S3 bucket name
terraform destroy -auto-approve -var="s3_bucket_name=my-etl-poc-nr-2025-xyz"

if ($LASTEXITCODE -eq 0) {
    Write-Host "Terraform destroy completed successfully!" -ForegroundColor Green
} else {
    Write-Host "Terraform destroy failed with exit code: $LASTEXITCODE" -ForegroundColor Red
}