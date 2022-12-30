output "websocket_api_execution_arn" {
  value = aws_apigatewayv2_api.websocket_api.execution_arn
}

output "websocket_url" {
  value = aws_apigatewayv2_stage.websocket_api.invoke_url
}

output "connection_url" {
  value = replace(aws_apigatewayv2_stage.websocket_api.invoke_url, "wss://", "https://")
}