/* s3 lambda bucket to store deplyment packages */
resource "random_pet" "lambda_bucket_name" {
  prefix = "lambda_bucket"
  length = 4
}

resource "aws_s3_bucket" "lambda" {
  bucket = random_pet.lambda_bucket_name.id
  force_destroy = true
}

resource "aws_s3_bucket_acl" "lambda_acl" {
  bucket = aws_s3_bucket.lambda.id
  acl    = "private"
}

/* lambda functions */
resource "aws_lambda_function" "onconnect" {
  function_name = "onconnect"

  s3_bucket = aws_s3_bucket.lambda.id
  s3_key = aws_s3_object.onconnect_lambda.key

  runtime = "nodejs16.x"
  handler = "index.handler"

  source_code_hash = data.archive_file.onconnect_lambda.output_base64sha256

  role = aws_iam_role.lambda.arn

  environment {
    variables = {
      CONNECTIONS_TABLE = var.connections_table.name
    }
  }
}

resource "aws_cloudwatch_log_group" "onconnect" {
  name = "/aws/lambda/${aws_lambda_function.onconnect.function_name}"
  retention_in_days = 30
}

resource "aws_lambda_function" "ondisconnect" {
  function_name = "ondisconnect"

  s3_bucket = aws_s3_bucket.lambda.id
  s3_key = aws_s3_object.ondisconnect_lambda.key

  runtime = "nodejs16.x"
  handler = "index.handler"

  source_code_hash = data.archive_file.ondisconnect_lambda.output_base64sha256

  role = aws_iam_role.lambda.arn

  environment {
    variables = {
      CONNECTIONS_TABLE = var.connections_table.name
    }
  }
}

resource "aws_cloudwatch_log_group" "ondisconnect" {
  name = "/aws/lambda/${aws_lambda_function.ondisconnect.function_name}"
  retention_in_days = 30
}

// join room lambda
resource "aws_lambda_function" "joinroom" {
  function_name = "joinroom"

  s3_bucket = aws_s3_bucket.lambda.id
  s3_key = aws_s3_object.joinroom_lambda.key

  runtime = "nodejs16.x"
  handler = "index.handler"

  source_code_hash = data.archive_file.joinroom_lambda.output_base64sha256

  role = aws_iam_role.lambda.arn

  environment {
    variables = {
      CONNECTIONS_TABLE = var.connections_table.name
    }
  }
}

resource "aws_cloudwatch_log_group" "joinroom" {
  name = "/aws/lambda/${aws_lambda_function.joinroom.function_name}"
  retention_in_days = 30
}

// sendmessage lambda
resource "aws_lambda_function" "sendmessage" {
  function_name = "sendmessage"

  s3_bucket = aws_s3_bucket.lambda.id
  s3_key = aws_s3_object.sendmessage_lambda.key

  runtime = "nodejs16.x"
  handler = "index.handler"

  source_code_hash = data.archive_file.sendmessage_lambda.output_base64sha256

  role = aws_iam_role.lambda.arn

  environment {
    variables = {
      CONNECTIONS_TABLE = var.connections_table.name
    }
  }
}

resource "aws_cloudwatch_log_group" "sendmessage" {
  name = "/aws/lambda/${aws_lambda_function.sendmessage.function_name}"
  retention_in_days = 30
}

/* iam roles and policies */
data "aws_iam_policy_document" "lambda_policy" {
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
data "aws_iam_policy_document" "lambda_inline" {
  statement {
    effect    = "Allow"
    actions   = [
      "execute-api:ManageConnections",
      "dynamodb:GetItem",
      "dynamodb:DeleteItem",
      "dynamodb:PutItem",
      "dynamodb:Scan",
      "dynamodb:Query",
      "dynamodb:UpdateItem",
      "dynamodb:BatchWriteItem",
      "dynamodb:BatchGetItem",
      "dynamodb:DescribeTable",
      "dynamodb:ConditionCheckItem"
    ]
    resources = [ 
      "${var.websocket_api_execution_arn}/*",
      "${var.connections_table.arn}"
    ]
  }
}

resource "aws_iam_role" "lambda" {
  name = "invoke-lambda"
  assume_role_policy = data.aws_iam_policy_document.lambda_policy.json

  inline_policy {
    name = "lambda_inline"
    policy = data.aws_iam_policy_document.lambda_inline.json
  }
}

resource "aws_iam_role_policy_attachment" "lambda_execution" {
  role       = aws_iam_role.lambda.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}