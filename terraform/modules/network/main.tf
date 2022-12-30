resource "aws_apigatewayv2_api" "websocket_api" {
  name = "websocket-api"
  protocol_type = "WEBSOCKET"
  route_selection_expression = "$request.body.action"
}

resource "aws_apigatewayv2_route" "websocket_api_connect" {
  api_id = aws_apigatewayv2_api.websocket_api.id
  route_key = "$connect"
  
  target = "integrations/${aws_apigatewayv2_integration.websocket_api_connect.id}"
}

resource "aws_apigatewayv2_integration" "websocket_api_connect" {
  api_id = aws_apigatewayv2_api.websocket_api.id
  integration_type = "AWS_PROXY"
  integration_uri = var.onconnect_lambda.invoke_arn
  
  integration_method = "POST"
  connection_type = "INTERNET"
  content_handling_strategy = "CONVERT_TO_TEXT"
  passthrough_behavior = "WHEN_NO_MATCH"

}

resource "aws_lambda_permission" "websocket_api_connect" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  principal     = "apigateway.amazonaws.com"
  function_name = var.onconnect_lambda.function_name

  source_arn = "${aws_apigatewayv2_api.websocket_api.execution_arn}/*/*"
}

# resource "aws_apigatewayv2_route" "websocket_api_disconnect" {
#   api_id = aws_apigatewayv2_api.websocket_api.id
#   route_key = "$disconnect"
# }

# resource "aws_apigatewayv2_route" "websocket_api_default" {
#   api_id = aws_apigatewayv2_api.websocket_api.id
#   route_key = "$default"
# }

resource "aws_apigatewayv2_route" "websocket_api_sendmessage" {
  api_id = aws_apigatewayv2_api.websocket_api.id
  route_key = "sendmessage"

  target = "integrations/${aws_apigatewayv2_integration.websocket_api_sendmessage.id}"
}

resource "aws_apigatewayv2_integration" "websocket_api_sendmessage" {
  api_id = aws_apigatewayv2_api.websocket_api.id
  integration_type = "AWS_PROXY"
  integration_uri = var.sendmessage_lambda.invoke_arn
  
  integration_method = "POST"
  connection_type = "INTERNET"
  content_handling_strategy = "CONVERT_TO_TEXT"
  passthrough_behavior = "WHEN_NO_MATCH"
}

resource "aws_lambda_permission" "websocket_api_sendmessage" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  principal     = "apigateway.amazonaws.com"
  function_name = var.sendmessage_lambda.function_name

  source_arn = "${aws_apigatewayv2_api.websocket_api.execution_arn}/*/*"
}

resource "aws_apigatewayv2_stage" "websocket_api" {
  api_id = aws_apigatewayv2_api.websocket_api.id
  name = "prod"

  auto_deploy = true
}