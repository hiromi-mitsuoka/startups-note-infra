# ECS

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group
resource "aws_cloudwatch_log_group" "for_ecs" {
  name = "/ecs/startups-note"
  retention_in_days = 3 # TODO: 本格運用時は日数考慮する

  tags = {
    Name = "startups-note-ecs"
  }
}


# NOTE: Not move

# Elasticsearch

# resource "aws_cloudwatch_log_group" "for_es" {
#   name = "es/startups-note"
#   retention_in_days = 3 # TODO: 本格運用時は日数考慮する

#   log_publishing_options {
#     cloudwatch_log_group_arn = aws_cloudwatch_log_group.for_es.arn
#     enabled = true
#     log_type = "ES_APPLICATION_LOGS"
#   }

#   vpc_options {
#     subnet_ids = [
#       aws_subnet.private_1a # TODO: マルチAZの場合、同期方法を考える
#     ]

#     security_group_ids = [aws_security_group.es.id]
#   }

#   tags = {
#     Name = "startups-note-ecs"
#   }
# }

# resource "aws_cloudwatch_log_resource_policy" "for_es" {
#   policy_name = "startups-note-cloud-watch-log-es"

#   policy_document = <<CONFIG
#     {
#       "Version": "2012-10-17",
#       "Statement": [
#         {
#           "Effect": "Allow",
#           "Principal": {
#             "Service": "es.amazonaws.com"
#           },
#           "Action": [
#             "logs:PutLogEvents",
#             "logs:PutLogEventsBatch",
#             "logs:CreateLogStream"
#           ],
#           "Resource": "arn:aws:logs:*"
#         }
#       ]
#     }
#   CONFIG
# }