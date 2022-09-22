// Creates NLB.
resource "aws_lb" "web" {
  name               = var.elb_name
  internal           = false
  load_balancer_type = var.lb_type

  subnets = var.subnets_ids
  tags = {
    nlb_terraform = "web"
  }
}


// Creates target group.
resource "aws_lb_target_group" "web" {
  name     = var.target_group_name
  port     = var.target_group_port
  protocol = "TCP"
  vpc_id   = var.vpc_id
  tags = {
    target_group_terraform = "web"
  }
}

resource "aws_lb_listener" "web" {
  load_balancer_arn = aws_lb.web.arn
  port              = var.lb_listener_port
  protocol          = "TCP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web.arn
  }
 
}
