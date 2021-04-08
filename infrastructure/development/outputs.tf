output "WEB_CLIENT_DOMAIN_DEV" {
  value = module.storage.web-client-domain-name
}

output "WEB_ADMIN_DOMAIN_DEV" {
  value = module.storage.web-admin-domain-name
}

output "WEB_CLIENT_BUCKET_DEV" {
  value = module.storage.web-client-bucket-name
}

output "WEB_ADMIN_BUCKET_DEV" {
  value = module.storage.web-admin-bucket-name
}

output "ECR_REPOSITORY_NAME_DEV" {
  value = module.ecs-service.ecr-repository-name
}

output "ECS_APP_NAME_DEV" {
  value = module.ecs-service.ecs-app-name
}

output "ECS_SERVICE_NAME_DEV" {
  value = module.ecs-service.ecs-service-name
}

output "ECS_CLUSTER_NAME_DEV" {
  value = module.ecs-service.ecs-cluster-name
}

output "ALB_DOMAIN_NAME_DEV" {
  value = module.scaling.alb-dns-name
}
