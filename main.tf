terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "ap-south-1" # or your preferred AWS region
}

module "glue" {
  source = "./modules/glue"
  name   = "etl-glue-job"
}

module "eventbridge" {
  source     = "./modules/eventbridge"
  lambda_arn = module.lambda.lambda_arn
}

module "s3" {
  source         = "./modules/s3"
  s3_bucket_name = var.s3_bucket_name
}

module "lambda" {
  source      = "./modules/lambda"
  name_prefix = "etl-lambda"
  env         = "dev"
  bucket_name = module.s3.bucket_name
  bucket_arn  = module.s3.bucket_arn
}
