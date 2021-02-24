resource "aws_db_subnet_group" "db-subnet" {
  name        = "${var.APP_NAME}-${var.ENV}-db-subnet-group"
  description = "RDS subnet group"
  subnet_ids  = var.DB_SUBNETS
}

resource "aws_db_parameter_group" "db-parameters" {
  name        = "${var.APP_NAME}-${var.ENV}-db-parameters"
  family      = "postgres12"
  description = "RDS parameter group"

  parameter {
    name  = "max_allowed_packet"
    value = "16777216"
  }
}

resource "aws_db_instance" "db" {
  allocated_storage       = 20
  engine                  = "postgres"
  engine_version          = "12.5.1"
  instance_class          = "db.t2.micro"
  identifier              = "postgres"
  name                    = "${var.APP_NAME}-${var.ENV}-db"
  username                = var.DB_USERNAME
  password                = var.DB_PASSWORD
  db_subnet_group_name    = aws_db_subnet_group.db-subnet.name
  parameter_group_name    = aws_db_parameter_group.db-parameters.name
  multi_az                = "false"
  vpc_security_group_ids  = var.DB_SECURITY_GROUPS
  storage_type            = "gp2"
  backup_retention_period = 30
  availability_zone       = var.DB_AZ
  skip_final_snapshot     = true

  tags = {
    Name = "${var.APP_NAME}-${var.ENV}-db"
  }
}
