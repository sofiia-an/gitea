resource "aws_lb" "load_balancer" {
    name               = "${var.application}-lb"
    internal           = false
    load_balancer_type = "application"
    security_groups    = [var.lb_sg]
    subnets            = var.subnets
    idle_timeout       = 1200

    tags = {
      Name = "${var.application}-lb"
    }
}

resource "aws_lb_target_group" "lb_target_group" {
  name        = var.target_group_name
  port        = var.target_port
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "instance"

  stickiness {
    enabled   = true
    type      = "lb_cookie"
  }

  health_check {
    path                = "/"
    port                = "3000"
    protocol            = "HTTP"
    timeout             = 5
    interval            = 10
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener" "application" {
  load_balancer_arn = aws_lb.load_balancer.arn
  port              = var.listener_port
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lb_target_group.arn
  }
}

resource "aws_lb_target_group_attachment" "ec2_attach" {
  for_each = {
    for idx, instance in var.instances:
    idx => instance
}
  target_group_arn = aws_lb_target_group.lb_target_group.arn
  target_id        = each.value.id
  port             = 3000
}
