resource "aws_cloudwatch_log_group" "ecs" {
  name              = "/ecs/${var.environment}"
  retention_in_days = 14
}

resource "aws_ecs_cluster" "this" {
  name = "${var.environment}-cluster"
}

resource "aws_iam_role" "execution_role" {
  name = "${var.environment}-ecs-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ecs" {
  role       = aws_iam_role.execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_ecs_task_definition" "app" {

  family                   = "${var.environment}-app"

  cpu                      = "512"
  memory                   = "1024"

  network_mode             = "awsvpc"

  requires_compatibilities = ["FARGATE"]

  execution_role_arn       = aws_iam_role.execution_role.arn

  container_definitions = jsonencode([
    {
      name = "website"

      image = var.image_uri

      essential = true

      portMappings = [
        {
          containerPort = 80
        }
      ]

      environment = [
        {
          name  = "DB_HOST"
          value = var.db_endpoint
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"

        options = {
          awslogs-group         = aws_cloudwatch_log_group.ecs.name
          awslogs-region        = "ap-south-1"
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
}

resource "aws_ecs_service" "app" {

  name            = "${var.environment}-service"

  cluster         = aws_ecs_cluster.this.id

  task_definition = aws_ecs_task_definition.app.arn

  desired_count   = 1

  launch_type     = "FARGATE"

  network_configuration {
    subnets = var.private_subnets
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = "website"
    container_port   = 80
  }
}

resource "aws_security_group" "ecs" {

  name   = "${var.environment}-ecs-sg"
  vpc_id = var.vpc_id

  ingress {

    from_port = 80
    to_port   = 80
    protocol  = "tcp"

    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {

    from_port = 0
    to_port   = 0
    protocol  = "-1"

    cidr_blocks = ["0.0.0.0/0"]
  }
}
