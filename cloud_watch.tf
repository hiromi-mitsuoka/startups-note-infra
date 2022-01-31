# ECS

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group
resource "aws_cloudwatch_log_group" "for_ecs" {
  name = "/ecs/startups-note"
  retention_in_days = 3 # TODO: 本格運用時は日数考慮する

  tags = {
    Name = "startups-note-ecs"
  }
}

# ECS Scheduled Tasks (RSS)
resource "aws_cloudwatch_log_group" "for_ecs_scheduled_tasks" {
  name = "/ecs-scheduled-tasks/rss-batch"
  retention_in_days = 3 # retain log events
}

# Set events rule
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_rule
resource "aws_cloudwatch_event_rule" "rss_batch" {
  name = "startups-note-rss-batch"
  description = "Get articles regularly"

  # https://docs.aws.amazon.com/AmazonCloudWatch/latest/events/ScheduledEvents.html
  # Use UTC time zone
  # rule that is triggered every day, at 0 and 30 minutes (UTC).

  # schedule_expression = "rate(10 minutes)" # For test

  # 16:00, 6:00 JST
  schedule_expression = "cron(0 7,21 * * ? *)"
}

# Define the job to be executed.
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_target
resource "aws_cloudwatch_event_target" "rss_batch" {
  target_id = "startups-note-rss-batch" # The unique target assignment ID. If missing, will generate a random, unique id.
  rule = aws_cloudwatch_event_rule.rss_batch.name
  role_arn = module.startups_note_ecs_rss_batch_role.iam_role_arn
  arn = aws_ecs_cluster.startups_note.arn

  ecs_target {
    launch_type = "FARGATE"
    task_count = 1 # The number of tasks to create based on the TaskDefinition. The default is 1.

    # Specifies the platform version for the task. Specify only the numeric portion of the platform version, such as 1.1.0. This is used only if LaunchType is FARGATE. For more information about valid platform versions, see AWS Fargate Platform Versions.
    # https://docs.aws.amazon.com/AmazonECS/latest/developerguide/platform_versions.html
    platform_version = "1.3.0"
    task_definition_arn = aws_ecs_task_definition.rss_batch.arn

    network_configuration {
      assign_public_ip = "false"
      subnets = [
        aws_subnet.private_1a.id,
        aws_subnet.private_1c.id,
      ]
    }
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