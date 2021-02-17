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
