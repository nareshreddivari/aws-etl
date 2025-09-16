variable "name_prefix" {
  description = "Prefix for naming Lambda resources"
  type        = string
}

variable "env" {
  description = "Environment (dev, qa, prod)"
  type        = string
}

variable "bucket_name" {
  description = "S3 bucket name"
  type        = string
}

variable "bucket_arn" {
  description = "S3 bucket ARN"
  type        = string
}
