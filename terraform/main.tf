module "network" {
  source = "./modules/network"

  onconnect_lambda = module.serverless.onconnect_lambda
  sendmessage_lambda = module.serverless.sendmessage_lambda
}

module "serverless" {
  source = "./modules/serverless"

  websocket_api_execution_arn = module.network.websocket_api_execution_arn
}