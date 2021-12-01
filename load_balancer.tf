# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb
resource "aws_lb" "startups_note_alb" {
  # Note: name = "startups-note-alb"が削除できず残っている
  name = "startups-note-lb"
  load_balancer_type = "application" # ALB
  internal = false # internet (If true, the LB will be internal.)
  idle_timeout = 60 # (Optional) The time in seconds that the connection is allowed to be idle. Only valid for Load Balancers of type application. Default: 60.
  enable_deletion_protection = false # TODO: 本格運用時削除保護変更

  subnets = [
    aws_subnet.public_1a.id,
    aws_subnet.public_1c.id
  ]

  access_logs {
    bucket = aws_s3_bucket.alb_log.id
    enabled = true
  }

  security_groups = [
    module.http_sg.security_group_id,
    module.https_sg.security_group_id,
    module.http_redirect_sg.security_group_id,
  ]
}



