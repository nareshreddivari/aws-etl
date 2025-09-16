# File: pre-destroy-check.ps1
# Usage: Run before destroy-with-cleanup.ps1 to validate and preview what will be destroyed

Write-Host "Pre-Destroy Validation Check" -ForegroundColor Yellow
Write-Host "=============================" -ForegroundColor Yellow

# Check AWS CLI availability
Write-Host "Checking AWS CLI..." -ForegroundColor Cyan
try {
    $awsVersion = aws --version 2>$null
    Write-Host "✅ AWS CLI found: $awsVersion" -ForegroundColor Green
} catch {
    Write-Host "❌ AWS CLI not found or not configured" -ForegroundColor Red
    exit 1
}

# Check AWS credentials
Write-Host "Checking AWS credentials..." -ForegroundColor Cyan
try {
    $identity = aws sts get-caller-identity --output json | ConvertFrom-Json
    Write-Host "✅ AWS credentials valid for: $($identity.Arn)" -ForegroundColor Green
} catch {
    Write-Host "❌ AWS credentials not configured or invalid" -ForegroundColor Red
    exit 1
}

# Check Terraform availability
Write-Host "Checking Terraform..." -ForegroundColor Cyan
try {
    $tfVersion = terraform version
    Write-Host "✅ Terraform found: $($tfVersion.Split("`n")[0])" -ForegroundColor Green
} catch {
    Write-Host "❌ Terraform not found" -ForegroundColor Red
    exit 1
}

# Check if Terraform state exists
Write-Host "Checking Terraform state..." -ForegroundColor Cyan
if (Test-Path "terraform.tfstate") {
    Write-Host "✅ Terraform state file found" -ForegroundColor Green
    
    # Show current resources
    Write-Host "Current Terraform resources:" -ForegroundColor Cyan
    terraform show -json | ConvertFrom-Json | Select-Object -ExpandProperty values | Select-Object -ExpandProperty root_module | Select-Object -ExpandProperty resources | ForEach-Object {
        Write-Host "  - $($_.type): $($_.name)" -ForegroundColor White
    }
} else {
    Write-Host "⚠️  No Terraform state file found" -ForegroundColor Yellow
}

# Check S3 bucket
$bucketName = "my-etl-poc-nr-2025-xyz"
Write-Host "Checking S3 bucket: $bucketName" -ForegroundColor Cyan
try {
    $bucketExists = aws s3api head-bucket --bucket $bucketName 2>$null
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ S3 bucket exists" -ForegroundColor Green
        
        # Check bucket contents
        $objectCount = (aws s3 ls s3://$bucketName --recursive | Measure-Object).Count
        Write-Host "  - Objects in bucket: $objectCount" -ForegroundColor White
        
        if ($objectCount -gt 0) {
            Write-Host "  - Bucket will be emptied before destroy" -ForegroundColor Yellow
        }
    }
} catch {
    Write-Host "⚠️  S3 bucket not found or inaccessible" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "Pre-destroy check complete!" -ForegroundColor Green
Write-Host "Ready to run destroy-with-cleanup.ps1" -ForegroundColor Green