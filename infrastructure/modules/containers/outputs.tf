output "ecs-cluster-name" {
  value = aws_ecs_cluster.ecs-cluster.name
}

output "ecr-repository-name" {
  value = aws_ecr_repository.ecr-repository.name
}

output "ecs-service-name" {
  value = aws_ecs_service.ecs-service.name
}

output "ecs-app-name" {
  value = aws_ecs_task_definition.task-definition.family
}
