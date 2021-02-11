module "network" {
  source     = "../modules/network"
  APP_NAME   = var.APP_NAME
  ENV        = var.ENV
  AWS_REGION = var.AWS_REGION
}

module "security" {
  source         = "../modules/security"
  APP_NAME       = var.APP_NAME
  ENV            = var.ENV
  AWS_REGION     = var.AWS_REGION
  VPC_ID         = module.network.main-vpc-id
  CONTAINER_PORT = 5000
}

module "ecs-service" {
  source                            = "../modules/containers"
  APP_NAME                          = var.APP_NAME
  ENV                               = var.ENV
  AWS_REGION                        = var.AWS_REGION
  ECS_AMI_ID                        = var.ECS_AMI_ID
  ECS_INSTANCE_TYPE                 = var.ECS_INSTANCE_TYPE
  SUBNETS                           = module.network.subnet-ids
  ASG_MAX_SIZE                      = 2
  ECS_SECURITY_GROUPS               = ""
  CONTAINER_PORT                    = 5000
  ECS_SERVICE_IAM_ROLE              = ""
  ECS_SERVICE_IAM_POLICY_ATTACHMENT = ""
}
