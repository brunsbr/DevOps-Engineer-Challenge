#ALB, Listener and target Groups
# This file defines the Application Load Balancer (ALB), listeners, and target groups for the application.
# It includes the ALB configuration, target groups for blue and green deployments, and the listener for HTTP traffic.

# Application Load Balancer

resource "aws_lb" "app_alb" {
  name               = "aspnet-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [
    aws_subnet.public_a.id,
    aws_subnet.public_b.id
  ]

  tags = {
    Name = "aspnet-app-alb"
  }
}

resource "aws_lb_target_group" "blue" {
  name     = "tg-blue"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
  target_type = "ip"

  health_check {
    path                = "/health"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 3
    matcher             = "200-299"
  }

  tags = {
    Name = "blue"
  }
}

resource "aws_lb_target_group" "green" {
  name     = "tg-green"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
  target_type = "ip"

  health_check {
    path                = "/health"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 3
    matcher             = "200-299"
  }

  tags = {
    Name = "green"
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.app_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.blue.arn  # Initially sends traffic to the "blue"
  }
}