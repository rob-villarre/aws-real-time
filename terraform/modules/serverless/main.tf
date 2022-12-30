// https://www.serverlessguru.com/blog/terraform-create-and-deploy-aws-lambda

// s3
resource "aws_s3_bucket" "lambda_bucket" {
  bucket = "websocket-api-lambda-bucket"
  force_destroy = true  
  
}

resource "aws_s3_bucket_acl" "lambda_bucket_acl" {
  bucket = aws_s3_bucket.lambda_bucket.id
  acl    = "private"
}

// onconnect
data "archive_file" "onconnect_lambda" {
  type = "zip"

  source_dir  = "${var.lambda_source_path}/onconnect"
  output_path = "${var.lambda_source_path}/onconnect.zip"
}

resource "aws_s3_object" "onconnect_lambda" {
  bucket = aws_s3_bucket.lambda_bucket.id

  key    = "onconnect.zip"
  source = data.archive_file.onconnect_lambda.output_path

  etag = filemd5(data.archive_file.onconnect_lambda.output_path)
}

// sendmessage
data "archive_file" "sendmessage_lambda" {
  type = "zip"

  source_dir  = "${var.lambda_source_path}/sendmessage"
  output_path = "${var.lambda_source_path}/sendmessage.zip"
}

resource "aws_s3_object" "sendmessage_lambda" {
  bucket = aws_s3_bucket.lambda_bucket.id

  key    = "sendmessage.zip"
  source = data.archive_file.sendmessage_lambda.output_path

  etag = filemd5(data.archive_file.sendmessage_lambda.output_path)
}

// lambda
resource "aws_lambda_function" "onconnect_lambda" {
  function_name = "onconnect"

  s3_bucket = aws_s3_bucket.lambda_bucket.id
  s3_key = aws_s3_object.onconnect_lambda.key

  runtime = "nodejs16.x"
  handler = "index.handler"

  source_code_hash = data.archive_file.onconnect_lambda.output_base64sha256

  role = aws_iam_role.lambda_role.arn
}

resource "aws_cloudwatch_log_group" "onconnect_lambda" {
  name = "/aws/lambda/${aws_lambda_function.onconnect_lambda.function_name}"
  retention_in_days = 30
}

resource "aws_lambda_function" "sendmessage_lambda" {
  function_name = "sendmessage"

  s3_bucket = aws_s3_bucket.lambda_bucket.id
  s3_key = aws_s3_object.sendmessage_lambda.key

  runtime = "nodejs16.x"
  handler = "index.handler"

  source_code_hash = data.archive_file.sendmessage_lambda.output_base64sha256

  role = aws_iam_role.lambda_role.arn
}

resource "aws_cloudwatch_log_group" "sendmessage_lambda" {
  name = "/aws/lambda/${aws_lambda_function.sendmessage_lambda.function_name}"
  retention_in_days = 30
}

// iam
data "aws_iam_policy_document" "lambda_role_policy" {
  statement {
    effect = "Allow"
    principals {
      identifiers = ["lambda.amazonaws.com"]
      type        = "Service"
    }
    actions = ["sts:AssumeRole"]
  }
}

// iam
data "aws_iam_policy_document" "lambda_invoke_policies" {
  statement {
    effect    = "Allow"
    actions   = [ "execute-api:ManageConnections" ]
    resources = [ "${var.websocket_api_execution_arn}/*" ]
  }
}

resource "aws_iam_role" "lambda_role" {
  name = "basic-lambda-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_role_policy.json

  inline_policy {
    name = "lambda-invoke-policies"
    policy = data.aws_iam_policy_document.lambda_invoke_policies.json
  }
}

resource "aws_iam_role_policy_attachment" "lambda_execution_role_policy" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
