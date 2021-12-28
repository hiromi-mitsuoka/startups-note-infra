# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb
resource "aws_lb" "front" {
  drop_invalid_header_fields = "false"
  enable_deletion_protection = "false" # TODO: Set true when in full-scale operation.
  enable_http2 = "true"
  idle_timeout = "60"
  internal = "false" # If true, only use ipv4
  ip_address_type = "ipv4"
  load_balancer_type = "application"
  name = "startups-note-front-alb"

  subnets = [
    var.public_subnet_1a_id,
    var.public_subnet_1c_id
  ]

  access_logs {
    bucket = aws_s3_bucket.front_alb_accesslog_bucket.id
    enabled = true
  }

  security_groups = [
    module.front_http_sg.security_group_id,
    module.front_https_sg.security_group_id,
    module.front_http_redirect_sg.security_group_id
  ]
}
