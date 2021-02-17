# ECR

resource "aws_ecr_repository" "ecr-repository" {
  name = "${var.APP_NAME}-ecr-repository"
}

# ECS cluster

resource "aws_ecs_cluster" "ecs-cluster" {
  name = "${var.APP_NAME}-${var.ENV}-ecs-cluster"
}

# Task definition 

data "template_file" "task-definition-template" {
  template = file("${path.module}/templates/app.json.tpl")
  vars = {
    REPOSITORY_URL = replace(aws_ecr_repository.ecr-repository.repository_url, "https://", "")
    CONTAINER_PORT = var.CONTAINER_PORT
    APP_NAME       = var.APP_NAME
  }
}

resource "aws_ecs_task_definition" "task-definition" {
  family                = var.APP_NAME
  container_definitions = data.template_file.task-definition-template.rendered
}

# ECS service

resource "aws_ecs_service" "ecs-service" {
  name            = "${var.APP_NAME}-${var.ENV}-ecs-service"
  cluster         = aws_ecs_cluster.ecs-cluster.id
  task_definition = aws_ecs_task_definition.task-definition.arn
  desired_count   = 1
  iam_role        = var.ECS_SERVICE_IAM_ROLE
  depends_on      = [var.ECS_SERVICE_IAM_POLICY_ATTACHMENT]

  load_balancer {
    elb_name       = aws_elb.elb.name
    container_name = var.APP_NAME
    container_port = var.CONTAINER_PORT
  }
  lifecycle {
    ignore_changes = [task_definition]
  }
}


