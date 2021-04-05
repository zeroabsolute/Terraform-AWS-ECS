# Log group

resource "aws_cloudwatch_log_group" "cloudwatch-group" {
  name = "${var.APP_NAME}-log-group-${var.ENV}"

  tags = {
    Environment = var.ENV
    Application = var.APP_NAME
  }
}

# Alarms

resource "aws_cloudwatch_metric_alarm" "cpu-alarm-high" {
  alarm_name          = "${var.APP_NAME}-cpu-alarm-high-${var.ENV}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  threshold           = 10
  statistic           = "Average"
  actions_enabled     = true
  alarm_actions       = var.ALARM_ACTIONS_HIGH_CPU

  dimensions = {
    "AutoScalingGroupName" = var.AUTOSCALING_GROUP_NAME
  }
}

resource "aws_cloudwatch_metric_alarm" "cpu-alarm-low" {
  alarm_name          = "${var.APP_NAME}-cpu-alarm-low-${var.ENV}"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  threshold           = 10
  statistic           = "Average"
  actions_enabled     = true
  alarm_actions       = var.ALARM_ACTIONS_LOW_CPU

  dimensions = {
    "AutoScalingGroupName" = var.AUTOSCALING_GROUP_NAME
  }
}

resource "aws_cloudwatch_metric_alarm" "errors-5xx" {
  alarm_name                = "${var.APP_NAME}-5xx-errors-high-${var.ENV}"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = 2
  threshold                 = 0.1
  alarm_description         = "Request error rate has exceeded 10%"
  insufficient_data_actions = []
  alarm_actions             = var.ALARM_ACTIONS_HIGH_5xx_ERRORS

  metric_query {
    id          = "e1"
    expression  = "m2/m1"
    label       = "Error Rate"
    return_data = "true"
  }

  metric_query {
    id = "m1"

    metric {
      metric_name = "RequestCount"
      namespace   = "AWS/ApplicationELB"
      period      = 60
      stat        = "Sum"
      unit        = "Count"

      dimensions = {
        LoadBalancer = var.ALB_ARN_SUFFIX
      }
    }
  }

  metric_query {
    id = "m2"

    metric {
      metric_name = "HTTPCode_Target_5XX_Count"
      namespace   = "AWS/ApplicationELB"
      period      = 60
      stat        = "Sum"
      unit        = "Count"

      dimensions = {
        LoadBalancer = var.ALB_ARN_SUFFIX
      }
    }
  }
}
