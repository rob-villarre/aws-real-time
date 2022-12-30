resource "aws_dynamodb_table" "connections" {
  name = "connections"
  billing_mode = "PAY_PER_REQUEST"

  attribute {
    name = "connectionId"
    type = "S"
  }

  hash_key = "connectionId"
}