# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group
resource "aws_cloudwatch_log_group" "for_ecs" {
  name = "/ecs/startups-note"
  retention_in_days = 3 # TODO: 本格運用時は日数考慮する

  tags = {
    Name = "startups-note-ecs"
  }
}