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

resource "aws_subnet" "main-private-subnets" {
  for_each = var.SUBNETS

  vpc_id            = aws_vpc.main.id
  availability_zone = "${var.AWS_REGION}${each.key}"
  cidr_block        = "10.0.${each.value}.0/24"
  tags = {
    "Name" = "${var.APP_NAME}-${var.ENV}-subnet-${each.value}"
  }
}

resource "aws_internet_gateway" "main-gateway" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.APP_NAME}-${var.ENV}-vpc-gateway"
  }
}

resource "aws_route_table" "main-route-table" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main-gateway.id
  }

  tags = {
    Name = "${var.APP_NAME}-${var.ENV}-main-route-table"
  }
}

resource "aws_route_table_association" "table-association" {
  for_each = aws_subnet.main-private-subnets

  subnet_id      = each.value.id
  route_table_id = aws_route_table.main-route-table.id
}
