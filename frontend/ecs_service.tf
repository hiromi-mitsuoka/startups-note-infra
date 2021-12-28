# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ecs_task_definition
data "aws_ecs_task_definition" "front" {
  task_definition = aws_ecs_task_definition.front.family
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_service
resource "aws_ecs_service" "front" {
  name = "startups-note-front"
  cluster = aws_ecs_cluster.front.id

  task_definition = "${aws_ecs_task_definition.front.family}:${max(aws_ecs_task_definition.front.revision, data.aws_ecs_task_definition.front.revision)}"

  desired_count = 2
  deployment_minimum_healthy_percent = 100
  deployment_maximum_percent = 200
  launch_type = "FARGATE"
  platform_version = "1.3.0"
  # Seconds to ignore failing load balancer health checks on newly instantiated tasks to prevent premature shutdown, up to 2147483647.
  health_check_grace_period_seconds = 60
  scheduling_strategy = "REPLICA"

  network_configuration {
    subnets = [
      var.private_subnet_1a_id,
      var.private_subnet_1c_id
    ]

    security_groups = [
      module.front_http_sg.security_group_id,
      module.front_https_sg.security_group_id,
      module.front_http_sg_81.security_group_id,
    ]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.front_alb.arn
    container_name = "front-nginx"
    container_port = 81 # 81に修正してみた(taskも)
  }
}