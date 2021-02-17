variable "APP_NAME" {
  type = string
}

variable "ENV" {
  type = string
}

variable "AWS_REGION" {
  type = string
}

variable "VPC_ID" {
  type = string
}

variable "CONTAINER_PORT" {
  type = number
  default = 5000
}

variable "PUBLIC_KEY_PATH" {
  type = string
}