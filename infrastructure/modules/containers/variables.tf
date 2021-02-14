variable "APP_NAME" {
  type = string
}

variable "ENV" {
  type = string
}

variable "AWS_REGION" {
  type = string
}

variable "ECS_AMI_ID" {
  type = string
}

variable "ECS_INSTANCE_TYPE" {
  type = string
}

variable "SUBNETS" {
  type = list(string)
}

variable "ASG_MAX_SIZE" {
  type    = number
  default = 2
}

variable "ECS_SECURITY_GROUPS" {
  type    = list(string)
  default = []
}

variable "CONTAINER_PORT" {
  type    = number
  default = 5000
}

variable "ECS_SERVICE_IAM_ROLE" {
  type = string
}

variable "ECS_SERVICE_IAM_POLICY_ATTACHMENT" {
  type = any
}

variable "ELB_SECURITY_GROUPS" {
  type = list(string)
}

variable "EC2_INSTANCE_PROFILE" {
  type = string
}
