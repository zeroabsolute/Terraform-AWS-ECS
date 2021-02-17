# ECR definitions

resource "aws_ecr_repository" "ecr-repository" {
  name = "${var.APP_NAME}-ecr-repository"
}

# ECS definitions

resource "aws_ecs_cluster" "ecs-cluster" {
  name = "${var.APP_NAME}-${var.ENV}-ecs-cluster"
}

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

# Auto-scaling group definitions

resource "aws_launch_configuration" "launch-config" {
  name                 = "${var.APP_NAME}-${var.ENV}-launch-config"
  image_id             = var.ECS_AMI_ID
  instance_type        = var.ECS_INSTANCE_TYPE
  iam_instance_profile = var.EC2_INSTANCE_PROFILE
  security_groups      = var.ECS_SECURITY_GROUPS
  key_name             = var.ECS_INSTANCE_KEY_NAME
  user_data            = "#!/bin/bash\necho 'ECS_CLUSTER=${var.APP_NAME}-${var.ENV}-ecs-cluster' > /etc/ecs/ecs.config"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "ecs-autoscaling-group" {
  name                 = "${var.APP_NAME}-${var.ENV}-autoscaling-group"
  vpc_zone_identifier  = var.SUBNETS
  launch_configuration = aws_launch_configuration.launch-config.name
  min_size             = 1
  max_size             = var.ASG_MAX_SIZE

  tag {
    key                 = "Name"
    value               = "${var.APP_NAME}-${var.ENV}-autoscaling-group"
    propagate_at_launch = true
  }
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

# Load balancer definition

resource "aws_elb" "elb" {
  name = "${var.APP_NAME}-${var.ENV}-elb"

  listener {
    instance_port     = var.CONTAINER_PORT
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 30
    target              = "HTTP:${var.CONTAINER_PORT}/health"
    interval            = 60
  }

  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  subnets         = var.SUBNETS
  security_groups = var.ELB_SECURITY_GROUPS

  tags = {
    Name = "${var.APP_NAME}-${var.ENV}-elb"
  }
}
