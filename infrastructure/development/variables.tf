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
  default = "ami-0f8ee411ba3a66276"
}

variable "ECS_INSTANCE_TYPE" {
  default = "t2.micro"
}

variable "ECS_CONTAINER_PORT" {
  default = 5000
}

variable "ASG_MAX_SIZE" {
  default = 2
}