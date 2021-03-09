output "web-client-domain-name" {
  value = aws_s3_bucket.web-client.bucket_domain_name
}

output "web-admin-domain-name" {
  value = aws_s3_bucket.web-admin.bucket_domain_name
}
