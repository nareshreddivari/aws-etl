resource "aws_iam_role" "lambda_exec" {
  name = "${var.name_prefix}-lambda-exec-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_policy_attachment" "lambda_s3_access" {
  name       = "${var.name_prefix}-lambda-s3-access"
  roles      = [aws_iam_role.lambda_exec.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_policy_attachment" "lambda_logs" {
  name       = "${var.name_prefix}-lambda-logs"
  roles      = [aws_iam_role.lambda_exec.name]
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
}

resource "aws_lambda_function" "etl_transform" {
  function_name = "${var.name_prefix}-etl-transform-fn"
  runtime       = "python3.9"
  handler       = "lambda_function.lambda_handler"
  role          = aws_iam_role.lambda_exec.arn
  filename      = "${path.module}/lambda.zip"

  environment {
    variables = {
      STAGE = var.env
    }
  }
}

resource "aws_lambda_permission" "allow_s3_invoke" {
  statement_id  = "AllowS3Invoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.etl_transform.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = var.bucket_arn
}

resource "aws_s3_bucket_notification" "bucket_notify" {
  bucket = var.bucket_name

  lambda_function {
    lambda_function_arn = aws_lambda_function.etl_transform.arn
    events              = ["s3:ObjectCreated:*"]
    filter_prefix       = "extract/"
  }

  depends_on = [aws_lambda_permission.allow_s3_invoke]
}
