# Cluster, Task definitions and services, Green and Blue deployments.
# This file defines the ECS cluster, task definitions, and services for blue-green deployments.
# It includes the ECS cluster, task definitions for the application, and services for blue and green deployments.
# container_definitions are defined in the task definition, and the services are configured to use the ALB target groups.

# Cluster ECS
resource "aws_ecs_cluster" "main" {
  name = "aspnet-core-cluster"
}

# Task Definition
resource "aws_ecs_task_definition" "app" {
  family                   = "aspnet-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.fargate_cpu
  memory                   = var.fargate_memory
  execution_role_arn       = aws_iam_role.ecs_task_execution.arn

  container_definitions = jsonencode([
  {
    name  = "aspnet-core-api"
    image = "${aws_ecr_repository.app.repository_url}:${var.image_tag}"
    portMappings = [
      {
        containerPort = 80
        hostPort      = 80
      }
    ],
    environment = [
      {
        name  = "ASPNETCORE_ENVIRONMENT"
        value = "Production"
      },
      {
        name  = "API_BASE_URL"
        value = "https://api.example.com"
      }
    ],
    essential = true
  }
])
}

# Service BLUE
resource "aws_ecs_service" "blue" {
  name            = "aspnet-blue"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.app.arn
  launch_type     = "FARGATE"
  desired_count   = 1

  network_configuration {
    subnets         = [aws_subnet.public_a.id, aws_subnet.public_b.id]
    assign_public_ip = true
    security_groups = [aws_security_group.alb_sg.id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.blue.arn
    container_name   = "aspnet-core-api"
    container_port   = 80
  }

  deployment_minimum_healthy_percent = 100
  deployment_maximum_percent         = 200

  lifecycle {
    ignore_changes = [task_definition]  # To facilitate updates via the Terraform pipeline
  }

  depends_on = [aws_lb_listener.http]
}

# Service GREEN
resource "aws_ecs_service" "green" {
  name            = "aspnet-green"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.app.arn
  launch_type     = "FARGATE"
  desired_count   = 0 # Start stopped
  network_configuration {
    subnets         = [aws_subnet.public_a.id, aws_subnet.public_b.id]
    assign_public_ip = true
    security_groups = [aws_security_group.alb_sg.id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.green.arn
    container_name   = "aspnet-core-api"
    container_port   = 80
  }

  deployment_minimum_healthy_percent = 100
  deployment_maximum_percent         = 200

  lifecycle {
    ignore_changes = [task_definition]
  }

  depends_on = [aws_lb_listener.http]
}
