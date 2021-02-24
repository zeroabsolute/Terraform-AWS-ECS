output "ecs-security-group-id" {
  value = aws_security_group.ecs-security-group.id
}

output "ecs-service-role-arn" {
  value = aws_iam_role.ecs-service-role.arn
}

output "ecs-service-attachment" {
  value = aws_iam_policy_attachment.ecs-service-attachment
}

output "ecs-ec2-instance-profile" {
  value = aws_iam_instance_profile.ecs-ec2-role.id
}

output "elb-security-group" {
  value = aws_security_group.elb-security-group.id
}

output "db-security-group" {
  value = aws_security_group.db-security-group.id
}

output "keypair-name" {
  value = aws_key_pair.keypair.key_name
}
