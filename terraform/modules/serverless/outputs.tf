output "onconnect_lambda" {
  value = {
      function_name = aws_lambda_function.onconnect_lambda.function_name
      invoke_arn    = aws_lambda_function.onconnect_lambda.invoke_arn
    }
}

output "ondisconnect_lambda" {
  value = {
      function_name = aws_lambda_function.ondisconnect_lambda.function_name
      invoke_arn    = aws_lambda_function.ondisconnect_lambda.invoke_arn
    }
}

output "sendmessage_lambda" {
  value = {
    function_name = aws_lambda_function.sendmessage_lambda.function_name
    invoke_arn    = aws_lambda_function.sendmessage_lambda.invoke_arn
  }
}