module "network" {
  source = "./modules/network"

  onconnect_lambda = module.serverless.onconnect_lambda
}

module "serverless" {
  source = "./modules/serverless"
}