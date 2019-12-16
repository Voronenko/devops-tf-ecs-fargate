resource "aws_alb" "main" {
  name            = "${local.app_name}-app"
  subnets         = [aws_subnet.public.0.id, aws_subnet.public.1.id]
  security_groups = [aws_security_group.lb.id]
  tags = {
    Name = local.readable_env_name
    env = local.env
  }
}

resource "aws_alb_target_group" "app" {
  name            = "${local.app_name}-app"
  port        = var.app_port_public
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id
  target_type = "ip"
  tags = {
    Name = "${local.readable_env_name}-app"
    env = local.env
  }
}

# Redirect all traffic from the ALB to the target group
resource "aws_alb_listener" "front_end" {
  load_balancer_arn = aws_alb.main.id
  port              = var.app_port_public
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.app.id
    type             = "forward"
  }
}
