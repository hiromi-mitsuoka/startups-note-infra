# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener
# For confirm
resource "aws_lb_listener" "front_http" {
  load_balancer_arn = aws_lb.front.arn
  port = "80"
  protocol = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "It is HTTP of front."
      status_code = "200"
    }
  }
}

resource "aws_lb_listener" "front_https" {
  load_balancer_arn = aws_lb.front.arn
  port = "443"
  protocol = "HTTPS"
  certificate_arn = aws_acm_certificate.front.arn
  ssl_policy = "ELBSecurityPolicy-2016-08"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "It is HTTPS of front."
      status_code = "200"
    }
  }
}

resource "aws_lb_listener" "front_redirect_http_to_https" {
  load_balancer_arn = aws_lb.front.arn
  port = "8080"
  protocol = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port = "443"
      protocol = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener_rule
resource "aws_lb_listener_rule" "front" {
  listener_arn = aws_lb_listener.front_https.arn
  priority = 100

  action {
    type = "forward"
    target_group_arn = aws_lb_target_group.front_alb.arn
  }

  condition {
    path_pattern {
      values = ["/*"]
    }
  }
}