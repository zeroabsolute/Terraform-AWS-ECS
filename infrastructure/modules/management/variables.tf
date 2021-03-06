variable "APP_NAME" {
  type = string
}

variable "ENV" {
  type = string
}

variable "ALARM_ACTIONS_HIGH_CPU" {
  type = list(string)
}

variable "ALARM_ACTIONS_LOW_CPU" {
  type = list(string)
}

variable "AUTOSCALING_GROUP_NAME" {
  type = string
}
