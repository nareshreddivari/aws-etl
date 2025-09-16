# GitHub Actions Setup Guide

## Required Secrets

To run the GitHub workflows, you need to configure the following secrets in your GitHub repository:

### AWS Credentials
1. Go to your GitHub repository
2. Navigate to **Settings** → **Secrets and variables** → **Actions**
3. Add the following repository secrets:

| Secret Name | Description | Example Value |
|-------------|-------------|---------------|
| `AWS_ACCESS_KEY_ID` | Your AWS Access Key ID | `AKIAIOSFODNN7EXAMPLE` |
| `AWS_SECRET_ACCESS_KEY` | Your AWS Secret Access Key | `wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY` |

### Optional Environment Variables
You can also set these as repository variables (not secrets):

| Variable Name | Description | Default Value |
|---------------|-------------|---------------|
| `AWS_REGION` | AWS Region for deployment | `us-east-1` |
| `TF_VERSION` | Terraform version to use | `1.5.0` |

## Workflow Triggers

### 1. Automatic Triggers
- **Push to main/develop**: Runs validation and deploys to AWS
- **Pull Request to main**: Runs validation only (no deployment)

### 2. Manual Triggers
- **Workflow Dispatch**: Allows manual execution with options:
  - `deploy`: Deploy infrastructure
  - `destroy`: Destroy infrastructure  
  - `plan-only`: Run terraform plan only

## Security Features

### Built-in Security Scans
- **Checkov**: Terraform security and compliance scanning
- **Trivy**: Vulnerability scanning for dependencies and configurations
- **SARIF Upload**: Security scan results uploaded to GitHub Security tab

### Protection Rules
- Destroy operations require manual approval (production environment)
- State files are automatically backed up as artifacts
- Sensitive outputs are masked in logs

## Usage Examples

### Deploy Infrastructure
```bash
# Automatic on push to main
git push origin main

# Manual deployment
# Go to Actions tab → AWS ETL POC - Deploy & Destroy → Run workflow → Select "deploy"
```

### Destroy Infrastructure
```bash
# Manual only (requires approval)
# Go to Actions tab → AWS ETL POC - Deploy & Destroy → Run workflow → Select "destroy"
```

### Validation Only
```bash
# Automatic on PR
git checkout -b feature-branch
git push origin feature-branch
# Create PR to main branch
```

## Troubleshooting

### Common Issues

1. **AWS Credentials Error**
   - Verify AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY are correctly set
   - Ensure IAM user has necessary permissions for Terraform operations

2. **Terraform State Lock**
   - If deployment fails, state might be locked
   - Check AWS DynamoDB for state lock table (if using remote state)

3. **Lambda Zip Creation Failed**
   - Ensure lambda/handler.py exists
   - Check file permissions and directory structure

### Debug Steps
1. Check workflow logs in Actions tab
2. Verify all required files are present in repository
3. Ensure AWS credentials have proper permissions
4. Check Terraform configuration syntax

## Best Practices

1. **Branch Protection**: Enable branch protection rules for main branch
2. **Required Reviews**: Require PR reviews before merging to main
3. **Environment Secrets**: Use environment-specific secrets for different stages
4. **State Management**: Consider using remote state backend (S3 + DynamoDB)
5. **Monitoring**: Set up AWS CloudWatch alarms for deployed resources