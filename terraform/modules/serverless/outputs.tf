output "onconnect_lambda" {
  value = {
      function_name = aws_lambda_function.onconnect.function_name
      invoke_arn    = aws_lambda_function.onconnect.invoke_arn
    }
}

output "ondisconnect_lambda" {
  value = {
      function_name = aws_lambda_function.ondisconnect.function_name
      invoke_arn    = aws_lambda_function.ondisconnect.invoke_arn
    }
}

output "joinroom_lambda" {
  value = {
    function_name = aws_lambda_function.joinroom.function_name
    invoke_arn    = aws_lambda_function.joinroom.invoke_arn
  }
}

output "sendmessage_lambda" {
  value = {
    function_name = aws_lambda_function.sendmessage.function_name
    invoke_arn    = aws_lambda_function.sendmessage.invoke_arn
  }
}