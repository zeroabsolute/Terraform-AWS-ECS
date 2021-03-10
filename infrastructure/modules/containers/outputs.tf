output "ecs-cluster-name" {
  value = aws_ecs_cluster.ecs-cluster.name
}

output "ecr-repository-name" {
  value = aws_ecr_repository.ecr-repository.name
}