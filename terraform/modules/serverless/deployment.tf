/* Deployment Packages for Lambdas */

// onconnect
data "archive_file" "onconnect_lambda" {
  type = "zip"

  source_dir  = "${var.lambda_source_path}/onconnect"
  output_path = "${var.lambda_source_path}/onconnect.zip"
}

resource "aws_s3_object" "onconnect_lambda" {
  bucket = aws_s3_bucket.lambda.id

  key    = "onconnect.zip"
  source = data.archive_file.onconnect_lambda.output_path

  etag = filemd5(data.archive_file.onconnect_lambda.output_path)
}

// ondisconnect
data "archive_file" "ondisconnect_lambda" {
  type = "zip"

  source_dir  = "${var.lambda_source_path}/ondisconnect"
  output_path = "${var.lambda_source_path}/ondisconnect.zip"
}

resource "aws_s3_object" "ondisconnect_lambda" {
  bucket = aws_s3_bucket.lambda.id

  key    = "ondisconnect.zip"
  source = data.archive_file.ondisconnect_lambda.output_path

  etag = filemd5(data.archive_file.ondisconnect_lambda.output_path)
}

// joinroom
data "archive_file" "joinroom_lambda" {
  type = "zip"

  source_dir  = "${var.lambda_source_path}/joinroom"
  output_path = "${var.lambda_source_path}/joinroom.zip"
}

resource "aws_s3_object" "joinroom_lambda" {
  bucket = aws_s3_bucket.lambda.id

  key    = "joinroom.zip"
  source = data.archive_file.joinroom_lambda.output_path

  etag = filemd5(data.archive_file.joinroom_lambda.output_path)
}

// sendmessage
data "archive_file" "sendmessage_lambda" {
  type = "zip"

  source_dir  = "${var.lambda_source_path}/sendmessage"
  output_path = "${var.lambda_source_path}/sendmessage.zip"
}

resource "aws_s3_object" "sendmessage_lambda" {
  bucket = aws_s3_bucket.lambda.id

  key    = "sendmessage.zip"
  source = data.archive_file.sendmessage_lambda.output_path

  etag = filemd5(data.archive_file.sendmessage_lambda.output_path)
}
