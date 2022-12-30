output "connections_table" {
  value = {
    name: aws_dynamodb_table.connections.id,
    arn: aws_dynamodb_table.connections.arn
  }
}