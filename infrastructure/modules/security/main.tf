# ECS EC2 role

resource "aws_iam_role" "ecs-ec2-role" {
  name               = "${var.APP_NAME}-ecs-ec2-role-${var.ENV}"
  assume_role_policy = file("${path.module}/templates/ecs-ec2-role.json.tpl")
}

resource "aws_iam_instance_profile" "ecs-ec2-role" {
  name = "${var.APP_NAME}-ecs-ec2-role-${var.ENV}"
  role = aws_iam_role.ecs-ec2-role.name
}

resource "aws_iam_role_policy" "ecs-ec2-role-policy" {
  name   = "${var.APP_NAME}-ecs-ec2-role-policy-${var.ENV}"
  role   = aws_iam_role.ecs-ec2-role.id
  policy = file("${path.module}/templates/ecs-ec2-role-policy.json.tpl")
}

# ECS service role

resource "aws_iam_role" "ecs-service-role" {
  name               = "${var.APP_NAME}-ecs-service-role-${var.ENV}"
  assume_role_policy = file("${path.module}/templates/ecs-service-role.json.tpl")
}

resource "aws_iam_policy_attachment" "ecs-service-attachment" {
  name       = "${var.APP_NAME}-ecs-service-attachment-${var.ENV}"
  roles      = [aws_iam_role.ecs-service-role.name]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceRole"
}

# Security groups

resource "aws_security_group" "elb-security-group" {
  vpc_id      = var.VPC_ID
  name        = "${var.APP_NAME}-elb-sg-${var.ENV}"
  description = "Security group for ELB"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.APP_NAME}-elb-sg-${var.ENV}"
  }
}

resource "aws_security_group" "ecs-security-group" {
  vpc_id      = var.VPC_ID
  name        = "${var.APP_NAME}-ecs-sg-${var.ENV}"
  description = "Security group for ECS"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port       = var.CONTAINER_PORT
    to_port         = var.CONTAINER_PORT
    protocol        = "tcp"
    security_groups = [aws_security_group.elb-security-group.id]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.APP_NAME}-ecs-sg-${var.ENV}"
  }
}

resource "aws_security_group" "db-security-group" {
  vpc_id      = var.VPC_ID
  name        = "${var.APP_NAME}-db-sg-${var.ENV}"
  description = "Security group for RDS"

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    self        = true
  }
  tags = {
    Name = "${var.APP_NAME}-db-sg-${var.ENV}"
  }
}

# Keypairs

resource "aws_key_pair" "keypair" {
  key_name   = "${var.APP_NAME}-keypair-${var.ENV}"
  public_key = file(var.PUBLIC_KEY_PATH)
  lifecycle {
    ignore_changes = [public_key]
  }
}
