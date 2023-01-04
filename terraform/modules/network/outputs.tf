output "websocket_api_execution_arn" {
  value = aws_apigatewayv2_api.this.execution_arn
}

output "websocket_url" {
  value = aws_apigatewayv2_stage.production.invoke_url
}

output "connection_url" {
  value = replace(aws_apigatewayv2_stage.production.invoke_url, "wss://", "https://")
}