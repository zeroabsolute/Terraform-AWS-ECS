variable "APP_NAME" {
  type = string
}

variable "ENV" {
  type = string
}

variable "SNS_EMAIL_ADDRESSES" {
  type        = list(string)
  description = "Email address to send notifications to"
}

variable "SNS_PROTOCOL" {
  default     = "email"
  description = "SNS Protocol to use. email or email-json"
  type        = string
}

variable "SNS_STACK_NAME" {
  type        = string
  description = "Unique Cloudformation stack name that wraps the SNS topic."
}
