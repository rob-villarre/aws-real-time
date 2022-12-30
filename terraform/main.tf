module "network" {
  source = "./modules/network"

  onconnect_lambda = module.serverless.onconnect_lambda
  ondisconnect_lambda = module.serverless.ondisconnect_lambda
  sendmessage_lambda = module.serverless.sendmessage_lambda
}

module "serverless" {
  source = "./modules/serverless"

  websocket_api_execution_arn = module.network.websocket_api_execution_arn
  connections_table = module.database.connections_table
}

module "database" {
  source = "./modules/database"
}

output "api_urls" {
  value = {
    websocket_url = module.network.websocket_url,
    connection_url = module.network.connection_url
  }
}