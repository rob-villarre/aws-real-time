resource "aws_apigatewayv2_api" "this" {
  name = "websocket-api"
  protocol_type = "WEBSOCKET"
  route_selection_expression = "$request.body.action"
}

resource "aws_apigatewayv2_route" "connect" {
  api_id = aws_apigatewayv2_api.this.id
  route_key = "$connect"
  
  target = "integrations/${aws_apigatewayv2_integration.connect.id}"
}

resource "aws_apigatewayv2_integration" "connect" {
  api_id = aws_apigatewayv2_api.this.id
  integration_type = "AWS_PROXY"
  integration_uri = var.onconnect_lambda.invoke_arn
  
  integration_method = "POST"
  connection_type = "INTERNET"
  content_handling_strategy = "CONVERT_TO_TEXT"
  passthrough_behavior = "WHEN_NO_MATCH"
}

resource "aws_lambda_permission" "connect" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  principal     = "apigateway.amazonaws.com"
  function_name = var.onconnect_lambda.function_name

  source_arn = "${aws_apigatewayv2_api.this.execution_arn}/*/*"
}

resource "aws_apigatewayv2_route" "disconnect" {
  api_id = aws_apigatewayv2_api.this.id
  route_key = "$disconnect"

  target = "integrations/${aws_apigatewayv2_integration.disconnect.id}"
}

resource "aws_apigatewayv2_integration" "disconnect" {
  api_id = aws_apigatewayv2_api.this.id
  integration_type = "AWS_PROXY"
  integration_uri = var.ondisconnect_lambda.invoke_arn
  
  integration_method = "POST"
  connection_type = "INTERNET"
  content_handling_strategy = "CONVERT_TO_TEXT"
  passthrough_behavior = "WHEN_NO_MATCH"

}

resource "aws_lambda_permission" "disconnect" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  principal     = "apigateway.amazonaws.com"
  function_name = var.ondisconnect_lambda.function_name

  source_arn = "${aws_apigatewayv2_api.this.execution_arn}/*/*"
}

resource "aws_apigatewayv2_route" "joinroom" {
  api_id = aws_apigatewayv2_api.this.id
  route_key = "joinroom"

  target = "integrations/${aws_apigatewayv2_integration.joinroom.id}"
}

resource "aws_apigatewayv2_integration" "joinroom" {
  api_id = aws_apigatewayv2_api.this.id
  integration_type = "AWS_PROXY"
  integration_uri = var.joinroom_lambda.invoke_arn
  
  integration_method = "POST"
  connection_type = "INTERNET"
  content_handling_strategy = "CONVERT_TO_TEXT"
  passthrough_behavior = "WHEN_NO_MATCH"
}

resource "aws_lambda_permission" "joinroom" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  principal     = "apigateway.amazonaws.com"
  function_name = var.joinroom_lambda.function_name

  source_arn = "${aws_apigatewayv2_api.this.execution_arn}/*/*"
}

//////
resource "aws_apigatewayv2_route" "sendmessage" {
  api_id = aws_apigatewayv2_api.this.id
  route_key = "sendmessage"

  target = "integrations/${aws_apigatewayv2_integration.sendmessage.id}"
}

resource "aws_apigatewayv2_integration" "sendmessage" {
  api_id = aws_apigatewayv2_api.this.id
  integration_type = "AWS_PROXY"
  integration_uri = var.sendmessage_lambda.invoke_arn
  
  integration_method = "POST"
  connection_type = "INTERNET"
  content_handling_strategy = "CONVERT_TO_TEXT"
  passthrough_behavior = "WHEN_NO_MATCH"
}

resource "aws_lambda_permission" "sendmessage" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  principal     = "apigateway.amazonaws.com"
  function_name = var.sendmessage_lambda.function_name

  source_arn = "${aws_apigatewayv2_api.this.execution_arn}/*/*"
}

resource "aws_apigatewayv2_stage" "production" {
  api_id = aws_apigatewayv2_api.this.id
  name = "prod"

  auto_deploy = true
}