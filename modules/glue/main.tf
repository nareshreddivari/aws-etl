resource "aws_iam_role" "glue_exec" {
  name = "${var.name}-exec-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "glue.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "glue_policy" {
  role       = aws_iam_role.glue_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole"
}

resource "aws_glue_job" "this" {
  name     = var.name
  role_arn = aws_iam_role.glue_exec.arn

  command {
    name            = "glueetl"
    script_location = "s3://my-etl-bucket/scripts/etl_script.py"
  }
}
