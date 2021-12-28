# TODO: Change only https, redirect-to-https, not using http.

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.startups_note_alb.arn
  port = "80"
  protocol = "HTTP" # Application Load Balancers, valid values are HTTP and HTTPS, with a default of HTTP.

  default_action {
    type = "fixed-response" #  Information for creating an action that returns a custom HTTP response. Required if type is fixed-response.

    fixed_response {
      content_type = "text/plain"
      message_body = "It is HTTP"
      status_code = "200"
    }
  }
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.startups_note_alb.arn
  port = "443"
  protocol = "HTTPS"
  certificate_arn = aws_acm_certificate.startups_note.arn # SSL証明書
  ssl_policy = "ELBSecurityPolicy-2016-08" # defaultのセキュリティーポリシー、明記推奨

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "It is HTTPS"
      status_code = "200"
    }
  }
}

resource "aws_lb_listener" "redirect_http_to_https" {
  load_balancer_arn = aws_lb.startups_note_alb.arn
  port = "8080"
  protocol = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port = "443"
      protocol = "HTTPS"
      status_code = "HTTP_301" # permanent (HTTP_301) or temporary (HTTP_302).
    }
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener_rule
resource "aws_lb_listener_rule" "startups_note" {
  listener_arn = aws_lb_listener.https.arn
  priority = 100 # 小さいほど優先度高い

  action {
    type = "forward"
    target_group_arn = aws_lb_target_group.startups_note.arn
  }

  condition {
    # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener_rule#example-usage
    path_pattern {
      values = ["/*"]
    }

    # field = "path-pattern"
    # values = ["/*"]
  }
}