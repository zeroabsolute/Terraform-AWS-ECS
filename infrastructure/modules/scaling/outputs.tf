output "target-group-arn" {
  value = aws_alb_target_group.ecs-target-group.arn
}

output "autoscaling-policy-scale-up-arn" {
  value = aws_autoscaling_policy.autoscaling-policy-scale-up.arn
}

output "autoscaling-policy-scale-down-arn" {
  value = aws_autoscaling_policy.autoscaling-policy-scale-down.arn
}

output "ecs-autoscaling-group-name" {
  value = aws_autoscaling_group.ecs-autoscaling-group.name
}
