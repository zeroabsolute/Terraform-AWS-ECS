module "network" {
  source = "../modules/network"
  APP_NAME = var.APP_NAME
  ENV = var.ENV
  AWS_REGION = var.AWS_REGION
}