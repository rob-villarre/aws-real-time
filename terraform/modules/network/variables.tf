variable "onconnect_lambda" {
  type = object({
    invoke_arn = string
    function_name = string
  })
}