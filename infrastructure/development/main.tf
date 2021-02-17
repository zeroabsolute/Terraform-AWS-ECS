module "network" {
  source     = "../modules/network"
  APP_NAME   = var.APP_NAME
  ENV        = var.ENV
  AWS_REGION = var.AWS_REGION
}

module "security" {
  source          = "../modules/security"
  APP_NAME        = var.APP_NAME
  ENV             = var.ENV
  AWS_REGION      = var.AWS_REGION
  VPC_ID          = module.network.main-vpc-id
  CONTAINER_PORT  = var.ECS_CONTAINER_PORT
  PUBLIC_KEY_PATH = var.PUBLIC_KEY_PATH
}

module "ecs-service" {
  source                            = "../modules/containers"
  APP_NAME                          = var.APP_NAME
  ENV                               = var.ENV
  AWS_REGION                        = var.AWS_REGION
  ECS_AMI_ID                        = var.ECS_AMI_ID
  ECS_INSTANCE_TYPE                 = var.ECS_INSTANCE_TYPE
  SUBNETS                           = module.network.subnet-ids
  ASG_MAX_SIZE                      = var.ASG_MAX_SIZE
  ECS_SECURITY_GROUPS               = [module.security.ecs-security-group-id]
  CONTAINER_PORT                    = var.ECS_CONTAINER_PORT
  ECS_SERVICE_IAM_ROLE              = module.security.ecs-service-role-arn
  ECS_SERVICE_IAM_POLICY_ATTACHMENT = module.security.ecs-service-attachment
  EC2_INSTANCE_PROFILE              = module.security.ecs-ec2-instance-profile
  ELB_SECURITY_GROUPS               = [module.security.elb-security-group]
  ECS_INSTANCE_KEY_NAME             = module.security.keypair-name
}
