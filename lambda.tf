resource aws_lambda_function Cloudwatch_Log_tag {
  filename         = "lambda_function.zip"
  function_name    = "Cloudwatch_Log_tag_${var.env}"
  role             = aws_iam_role.Bounded_tag_logGroup.arn
  handler          = "lambda_function.lambda_handler"
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  timeout          = var.timeout
  memory_size      = var.memory_size
  tags             = var.tags
  kms_key_arn      = var.kms_key_arn
  runtime = "python3.8"

  environment {
    variables = {
      ENV = var.env
    }
  }
}

