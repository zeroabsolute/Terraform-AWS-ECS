resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true
  enable_classiclink   = false
  tags = {
    "Name" = "${var.APP_NAME}-${var.ENV}-vpc"
  }
}

resource "aws_subnet" "main-private" {
  for_each = var.SUBNETS

  vpc_id            = aws_vpc.main.id
  availability_zone = "${var.AWS_REGION}${each.key}"
  cidr_block        = "10.0.${each.value}.0/24"
}
