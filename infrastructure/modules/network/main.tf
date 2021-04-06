# VPC

resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true
  enable_classiclink   = false
  tags = {
    Name = "${var.APP_NAME}-vpc-${var.ENV}"
  }
}

# Subnets

resource "aws_subnet" "main-public-subnets" {
  for_each = var.SUBNETS

  vpc_id                  = aws_vpc.main.id
  availability_zone       = "${var.AWS_REGION}${each.key}"
  cidr_block              = "10.0.${each.value}.0/24"
  map_public_ip_on_launch = "true"
  tags = {
    Name = "${var.APP_NAME}-subnet-${each.value}-${var.ENV}"
  }
}

# Internet gateway

resource "aws_internet_gateway" "main-gateway" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.APP_NAME}-vpc-gateway-${var.ENV}"
  }
}

resource "aws_route_table" "main-route-table" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main-gateway.id
  }

  tags = {
    Name = "${var.APP_NAME}-main-route-table-${var.ENV}"
  }
}

resource "aws_route_table_association" "table-association" {
  for_each = aws_subnet.main-public-subnets

  subnet_id      = each.value.id
  route_table_id = aws_route_table.main-route-table.id
}

# Route 53

resource "aws_route53_record" "api" {
  zone_id = var.HOSTED_ZONE_ID # created manually beforehand
  name    = "api-${var.APP_NAME}-${var.ENV}.${var.DOMAIN}"
  type    = "A"
  alias {
    name                   = var.API_RECORD_ADDRESS
    zone_id                = var.API_ZONE_ID
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "web-client" {
  zone_id = var.HOSTED_ZONE_ID
  name    = "${var.APP_NAME}-${var.ENV}.${var.DOMAIN}"
  type    = "A"
  alias {
    name                   = var.WEB_CLIENT_RECORD_ADDRESS
    zone_id                = var.WEB_CLIENT_HOSTED_ZONE
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "web-admin" {
  zone_id = var.HOSTED_ZONE_ID
  name    = "admin-${var.APP_NAME}-${var.ENV}.${var.DOMAIN}"
  type    = "A"
  alias {
    name                   = var.WEB_ADMIN_RECORD_ADDRESS
    zone_id                = var.WEB_ADMIN_HOSTED_ZONE
    evaluate_target_health = true
  }
}
