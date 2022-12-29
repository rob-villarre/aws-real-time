output "onconnect_lambda" {
  value = {
      function_name   = aws_lambda_function.onconnect_lambda.function_name
      invoke_arn      = aws_lambda_function.onconnect_lambda.invoke_arn
    }
}