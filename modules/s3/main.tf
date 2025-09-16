resource "aws_s3_bucket" "etl_bucket" {
  bucket = var.s3_bucket_name

  tags = {
    Project = "aws-etl-poc"
    Env     = "dev"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "etl_bucket_encryption" {
  bucket = aws_s3_bucket.etl_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_object" "prefix_extract" {
  bucket  = aws_s3_bucket.etl_bucket.id
  key     = "extract/"
  content = ""
}

resource "aws_s3_object" "prefix_load" {
  bucket  = aws_s3_bucket.etl_bucket.id
  key     = "load/"
  content = ""
}


