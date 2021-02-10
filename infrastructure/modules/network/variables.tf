variable "APP_NAME" {
  type = string
}

variable "ENV" {
  type = string
}

variable "AWS_REGION" {
  type = string
}

variable "SUBNETS" {
  default = {
    "a" = 1
    "b" = 2
    "c" = 3
  }
}
