# ECR

resource "aws_ecr_repository" "ecr-repository" {
  name = "${var.APP_NAME}-ecr-repository-${var.ENV}"
}

# ECS cluster

resource "aws_ecs_cluster" "ecs-cluster" {
  name = "${var.APP_NAME}-ecs-cluster-${var.ENV}"
}

# Task definition 

data "template_file" "task-definition-template" {
  template = file("${path.module}/templates/app.json.tpl")
  vars = {
    REPOSITORY_URL       = replace(aws_ecr_repository.ecr-repository.repository_url, "https://", "")
    CONTAINER_PORT       = var.CONTAINER_PORT
    APP_NAME             = var.APP_NAME
    DATABASE_HOST        = var.DATABASE_HOST
    DATABASE_PORT        = var.DATABASE_PORT
    DATABASE_USER        = var.DATABASE_USER
    DATABASE_PASSWORD    = var.DATABASE_PASSWORD
    DATABASE_NAME        = var.DATABASE_NAME
    CLOUDWATCH_LOG_GROUP = var.CLOUDWATCH_LOG_GROUP
    AWS_REGION           = var.AWS_REGION
  }
}

resource "aws_ecs_task_definition" "task-definition" {
  family                = var.APP_NAME
  container_definitions = data.template_file.task-definition-template.rendered
}

# ECS service

resource "aws_ecs_service" "ecs-service" {
  name            = "${var.APP_NAME}-ecs-service-${var.ENV}"
  cluster         = aws_ecs_cluster.ecs-cluster.id
  task_definition = aws_ecs_task_definition.task-definition.arn
  desired_count   = var.ASG_MAX_SIZE
  iam_role        = var.ECS_SERVICE_IAM_ROLE
  depends_on      = [var.ECS_SERVICE_IAM_POLICY_ATTACHMENT]

  load_balancer {
    target_group_arn = var.TARGET_GROUP_ARN
    container_name   = var.APP_NAME
    container_port   = var.CONTAINER_PORT
  }
  lifecycle {
    ignore_changes = [task_definition]
  }
}


