output "lambda_function_name" {
  value = aws_lambda_function.etl_transform.function_name
}

output "lambda_arn" {
  value = aws_lambda_function.etl_transform.arn
}
