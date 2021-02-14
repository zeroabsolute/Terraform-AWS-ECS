# ECS EC2 role

resource "aws_iam_role" "ecs-ec2-role" {
  name               = "${var.APP_NAME}-${var.ENV}-ecs-ec2-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

}

resource "aws_iam_instance_profile" "ecs-ec2-role" {
  name = "${var.APP_NAME}-${var.ENV}-ecs-ec2-role"
  role = aws_iam_role.ecs-ec2-role.name
}

resource "aws_iam_role_policy" "ecs-ec2-role-policy" {
  name   = "${var.APP_NAME}-${var.ENV}-ecs-ec2-role-policy"
  role   = aws_iam_role.ecs-ec2-role.id
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
              "ecs:CreateCluster",
              "ecs:DeregisterContainerInstance",
              "ecs:DiscoverPollEndpoint",
              "ecs:Poll",
              "ecs:RegisterContainerInstance",
              "ecs:StartTelemetrySession",
              "ecs:Submit*",
              "ecs:StartTask",
              "ecr:GetAuthorizationToken",
              "ecr:BatchCheckLayerAvailability",
              "ecr:GetDownloadUrlForLayer",
              "ecr:BatchGetImage",
              "logs:CreateLogStream",
              "logs:PutLogEvents"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents",
                "logs:DescribeLogStreams"
            ],
            "Resource": [
                "arn:aws:logs:*:*:*"
            ]
        }
    ]
}
EOF

}

# ECS service role

resource "aws_iam_role" "ecs-service-role" {
  name               = "${var.APP_NAME}-${var.ENV}-ecs-service-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ecs.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

}

resource "aws_iam_policy_attachment" "ecs-service-attachment" {
  name       = "${var.APP_NAME}-${var.ENV}-ecs-service-attachment"
  roles      = [aws_iam_role.ecs-service-role.name]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceRole"
}

# Security groups

resource "aws_security_group" "elb-security-group" {
  vpc_id      = var.VPC_ID
  name        = "${var.APP_NAME}-${var.ENV}-elb-sg"
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
    Name = "${var.APP_NAME}-${var.ENV}-elb-sg"
  }
}

resource "aws_security_group" "ecs-security-group" {
  vpc_id      = var.VPC_ID
  name        = "${var.APP_NAME}-${var.ENV}-ecs-sg"
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

  tags = {
    Name = "${var.APP_NAME}-${var.ENV}-ecs-sg"
  }
}
