output "WEB_CLIENT_DOMAIN_STAG" {
  value = module.storage.web-client-domain-name
}

output "WEB_ADMIN_DOMAIN_STAG" {
  value = module.storage.web-admin-domain-name
}

output "WEB_CLIENT_BUCKET_STAG" {
  value = module.storage.web-client-bucket-name
}

output "WEB_ADMIN_BUCKET_STAG" {
  value = module.storage.web-admin-bucket-name
}

output "ECR_REPOSITORY_NAME" {
  value = module.ecs-service.ecr-repository-name
}