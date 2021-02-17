variable "APP_NAME" {
  type = string
}

variable "ENV" {
  type = string
}

variable "ECS_CLUSTER_NAME" {
  type = string
}

variable "ECS_AMI_ID" {
  type = string
}

variable "ECS_INSTANCE_TYPE" {
  type = string
}

variable "VPC_ID" {
  type = string
}

variable "SUBNETS" {
  type = list(string)
}

variable "ASG_MAX_SIZE" {
  type    = number
  default = 2
}

variable "ELB_SECURITY_GROUPS" {
  type = list(string)
}

variable "ECS_SECURITY_GROUPS" {
  type    = list(string)
  default = []
}

variable "EC2_INSTANCE_PROFILE" {
  type = string
}

variable "ECS_INSTANCE_KEY_NAME" {
  type = string
}
