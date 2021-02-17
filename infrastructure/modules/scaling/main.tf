# Launch config

resource "aws_launch_configuration" "launch-config" {
  name                 = "${var.APP_NAME}-${var.ENV}-launch-config"
  image_id             = var.ECS_AMI_ID
  instance_type        = var.ECS_INSTANCE_TYPE
  iam_instance_profile = var.EC2_INSTANCE_PROFILE
  security_groups      = var.ECS_SECURITY_GROUPS
  key_name             = var.ECS_INSTANCE_KEY_NAME
  user_data            = "#!/bin/bash\necho 'ECS_CLUSTER=${var.ECS_CLUSTER_NAME}' > /etc/ecs/ecs.config"

  lifecycle {
    create_before_destroy = true
  }
}

# Autoscaling group

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

# Application load balancer

resource "aws_alb" "ecs-load-balancer" {
  name            = "${var.APP_NAME}-${var.ENV}-load-balancer"
  security_groups = var.ELB_SECURITY_GROUPS
  subnets         = var.SUBNETS

  tags = {
    Name = "${var.APP_NAME}-${var.ENV}-load-balancer"
  }
}

# ALB target group

resource "aws_alb_target_group" "ecs-target-group" {
  name       = "${var.APP_NAME}-${var.ENV}-target-group"
  port       = "80"
  protocol   = "HTTP"
  vpc_id     = var.VPC_ID
  depends_on = [aws_alb.ecs-load-balancer]

  health_check {
    healthy_threshold   = "5"
    unhealthy_threshold = "2"
    interval            = "300"
    matcher             = "200"
    path                = "/health"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = "5"
  }

  tags = {
    Name = "${var.APP_NAME}-${var.ENV}-target-group"
  }
}

# ALB listener

resource "aws_alb_listener" "alb-listener" {
  load_balancer_arn = aws_alb.ecs-load-balancer.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.ecs-target-group.arn
    type             = "forward"
  }
}