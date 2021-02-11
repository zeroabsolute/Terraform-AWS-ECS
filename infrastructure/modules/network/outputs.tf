output "main-vpc-id" {
  value = aws_vpc.main.id
}

output "subnet-ids" {
  value = [
    for subnet in aws_subnet.main-private-subnets : subnet.id
  ]
}
