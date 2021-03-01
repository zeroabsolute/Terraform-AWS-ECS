variable "APP_NAME" {
  type = string
}

variable "ENV" {
  type = string
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

variable "TARGET_GROUP_ARN" {
  type = string
}

variable "DATABASE_HOST" {
  type = string
}

variable "DATABASE_PORT" {
  type = number
}

variable "DATABASE_USER" {
  type = string
}

variable "DATABASE_PASSWORD" {
  type = string
}

variable "DATABASE_NAME" {
  type = string
}

variable "AWS_REGION" {
  type = string
}

variable "CLOUDWATCH_LOG_GROUP" {
  type = string
}
