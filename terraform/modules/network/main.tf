resource "aws_apigatewayv2_api" "websocket_api" {
  name = "websocket-api"
  protocol_type = "WEBSOCKET"
  route_selection_expression = "$request.body.action"
}

resource "aws_apigatewayv2_route" "websocket_api_connect_route" {
  api_id = aws_apigatewayv2_api.websocket_api.id
  route_key = "$connect"   
}

resource "aws_apigatewayv2_route" "websocket_api_disconnect_route" {
  api_id = aws_apigatewayv2_api.websocket_api.id
  route_key = "$disconnect"
}

resource "aws_apigatewayv2_route" "websocket_api_default_route" {
  api_id = aws_apigatewayv2_api.websocket_api.id
  route_key = "$default"
}

resource "aws_apigatewayv2_route" "websocket_api_sendmessage_route" {
  api_id = aws_apigatewayv2_api.websocket_api.id
  route_key = "sendmessage"
}