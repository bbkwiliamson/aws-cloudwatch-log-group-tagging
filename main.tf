data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
data "archive_file" "lambda_zip" {
  type          = "zip"
  source_file   = "lambda_function.py"
  output_path   = "lambda_function.zip"
}
