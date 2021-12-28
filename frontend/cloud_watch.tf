# ECS

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group
resource "aws_cloudwatch_log_group" "front_for_ecs" {
  name = "/ecs/startups-note-front"
  retention_in_days = 3

  tags = {
    Name = "startups-note-front-ecs"
  }
}