variable "AWS_ACCESS_KEY" {
  default = ""
}

variable "AWS_SECRET_KEY" {
  default = ""
}

variable "AWS_REGION" {
  default     = "eu-central-1"
  description = "Germany (Frankfurt) Region"
}

variable "APP_NAME" {
  default = "gh"
}

variable "ENV" {
  default = "development"
}

variable "ECS_AMI_ID" {
  default = "ami-03201f9d49c2d89f4"
}

variable "ECS_INSTANCE_TYPE" {
  default = "t2.micro"
}

variable "ECS_CONTAINER_PORT" {
  default = 5000
}

variable "ASG_MAX_SIZE" {
  default = 1
}

variable "PUBLIC_KEY_PATH" {
  default = "keypair.pub"
}

variable "DB_USERNAME" {
  default = ""
}

variable "DB_PASSWORD" {
  default = ""
}

variable "DB_NAME" {
  default = "dev"
}

variable "SNS_EMAIL_RECEIVER" {
  default = ""
}

variable "SNS_STACK_NAME" {
  default = "sns-stack-738204592"
}

variable "HOSTED_ZONE_ID" {
  default = ""
}

variable "DOMAIN" {
  default = ""
}
