# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group
resource "aws_lb_target_group" "front_alb" {
  name = "startups-note-front"
  target_type = "ip" # Set ip when using ECS Fargate
  vpc_id = var.vpc_id
  port = 81 # frontはここから81にすればいける？
  protocol = "HTTP"
  # Amount time for Elastic Load Balancing to wait before changing the state of a deregistering target from draining to unused.
  deregistration_delay = 300

  health_check {
    path = "/"
    # Number of consecutive health checks successes required before considering an unhealthy target healthy. Defaults to 3.
    healthy_threshold = 5
    unhealthy_threshold = 2
    # Amount of time, in seconds, during which no response means a failed health check.
    timeout = 5
    # Between health checks of an individual target.
    interval = 30
    # Response codes to use when checking for a healthy responses from a target.
    matcher = 200
    port = "traffic-port"
    protocol = "HTTP"
  }

  depends_on = [aws_lb.front]
}
