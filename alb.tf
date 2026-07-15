resource "aws_lb" "paynest_alb" {
  name               = "${var.project}-alb"
  internal           = false
  security_groups    = [aws_security_group.paynest_alb_sg.id]
  subnets            = aws_subnet.public[*].id
  load_balancer_type = "application"
  enable_deletion_protection = false

  tags = merge(local.common_tags, { Name = "${var.project}-alb" })
}

resource "aws_lb_target_group" "paynest_alb_target_group" {
  name     = "${var.project}-alb-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
    matcher             = "200-299"
  }

  tags = merge(local.common_tags, { Name = "${var.project}-alb-target-group" })
}

resource "aws_lb_listener" "paynest_alb_listener" {
  load_balancer_arn = aws_lb.paynest_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.paynest_alb_target_group.arn
  }
}