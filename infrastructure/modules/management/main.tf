# Log group

resource "aws_cloudwatch_log_group" "cloudwatch-group" {
  name = "${var.APP_NAME}-${var.ENV}-log-group"

  tags = {
    Environment = var.ENV
    Application = var.APP_NAME
  }
}

# Alarms

resource "aws_cloudwatch_metric_alarm" "cpu-alarm-high" {
  alarm_name          = "${var.APP_NAME}-${var.ENV}-cpu-alarm-high"
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
  alarm_name          = "${var.APP_NAME}-${var.ENV}-cpu-alarm-low"
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
