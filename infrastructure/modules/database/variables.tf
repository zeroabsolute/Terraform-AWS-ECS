variable "APP_NAME" {
  type = string
}

variable "ENV" {
  type = string
}

variable "DB_SUBNETS" {
  type = list(string)
}

variable "DB_USERNAME" {
  type = string
}

variable "DB_PASSWORD" {
  type = string
}

variable "DB_SECURITY_GROUPS" {
  type = list(string)
}

variable "DB_AZ" {
  type = string
}
