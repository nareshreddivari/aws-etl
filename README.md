# AWS ETL Extended PoC

This PoC demonstrates an AWS ETL pipeline with Terraform, using modular IaC and CI/CD pipelines.

## Features
- AWS Lambda (Python handler)
- AWS Glue Job (Python ETL script)
- EventBridge Rule (Triggers Lambda every 5 min)
- Modular Terraform structure
- GitHub Actions & Azure DevOps pipelines
- Security scans (Checkov, Trivy)

## How to Run
1. Configure AWS credentials in GitHub/Azure DevOps secrets.
2. Run pipeline to deploy Lambda, Glue, EventBridge.
3. Monitor logs in CloudWatch.
