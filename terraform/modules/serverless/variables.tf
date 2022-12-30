variable "lambda_source_path" {
  type = string
  default = "../lambda"
  description = "directory path to lambda source code"
}

variable "websocket_api_execution_arn" {
  type = string
}

variable "connections_table" {
  type = object({
    name: string,
    arn: string
  })
}