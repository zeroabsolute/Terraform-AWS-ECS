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

variable "HOSTED_ZONE_ID" {
  type = string
}

variable "API_RECORD_ADDRESS" {
  type = string
}

variable "WEB_CLIENT_RECORD_ADDRESS" {
  type = string
}

variable "WEB_ADMIN_RECORD_ADDRESS" {
  type = string
}

variable "API_ZONE_ID" {
  type = string
}

variable "WEB_CLIENT_HOSTED_ZONE" {
  type = string
}

variable "WEB_ADMIN_HOSTED_ZONE" {
  type = string
}

variable "DOMAIN" {
  type = string
}
