output "web-client-domain-name" {
  value = aws_s3_bucket.web-client.bucket_domain_name
}

output "web-admin-domain-name" {
  value = aws_s3_bucket.web-admin.bucket_domain_name
}

output "web-client-bucket-name" {
  value = aws_s3_bucket.web-client.id
}

output "web-admin-bucket-name" {
  value = aws_s3_bucket.web-admin.id
}

output "web-client-website-domain" {
  value = aws_s3_bucket.web-client.website_domain
}

output "web-admin-website-domain" {
  value = aws_s3_bucket.web-admin.website_domain
}

output "web-client-hosted-zone" {
  value = aws_s3_bucket.web-client.hosted_zone_id
}

output "web-admin-hosted-zone" {
  value = aws_s3_bucket.web-admin.hosted_zone_id
}
