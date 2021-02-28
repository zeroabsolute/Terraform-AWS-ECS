output "db-endpoint" {
  value = aws_db_instance.db.endpoint
}

output "db-port" {
  value = aws_db_instance.db.port
}
