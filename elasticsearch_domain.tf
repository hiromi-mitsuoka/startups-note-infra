# NOTE: applicationとどう繋ぐの？（そもそもローカルでどう繋がっているんだっけ？）
# TODO: マルチAZ化


data "aws_region" "current" {}

output "name" {
  value = data.aws_region.current.name
}

data "aws_caller_identity" "current" {}

output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

# Commented out because it cannot be deleted during destroy.
# resource "aws_iam_service_linked_role" "startups_note" {
#   aws_service_name = "es.amazonaws.com"
# }

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticsearch_domain
resource "aws_elasticsearch_domain" "startups_note" {
  domain_name = "startups-note"
  elasticsearch_version = "7.10" # Confirm from Gemfile.lock

  cluster_config {
    instance_type = "t2.medium.elasticsearch"
    # zone_awareness_enabled = true # マルチAZ
    instance_count = 1 # TODO: ESのインスタンス考える
  }

  ebs_options {
    ebs_enabled = "true"
    volume_type = "gp2"
    volume_size = "10"
  }

  vpc_options {
    subnet_ids = [ # TODO: インスタンス数によって増減させる
      aws_subnet.private_1a.id,
      # aws_subnet.private_1c.id,
    ]

    security_group_ids = [module.es_sg.security_group_id]
  }

  # TODO: snapshot_options追加する

  access_policies = <<POLICY
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "AWS": "*"
        },
        "Action": "es:*",
        "Resource": "arn:aws:es:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:domain/startups-note/*"
      }
    ]
  }
  POLICY

  log_publishing_options {
    cloudwatch_log_group_arn = aws_cloudwatch_log_group.startups_note_es.arn
    log_type = "ES_APPLICATION_LOGS"
  }

  # depends_on = [aws_iam_service_linked_role.startups_note]
}


# CloudWatch Logs

resource "aws_cloudwatch_log_group" "startups_note_es" {
  name = "startups-note-es"
}

resource "aws_cloudwatch_log_resource_policy" "startups_note_es" {
  policy_name = "startups-note-es"

  policy_document = <<CONFIG
    {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Effect": "Allow",
          "Principal": {
            "Service": "es.amazonaws.com"
          },
          "Action": [
            "logs:PutLogEvents",
            "logs:PutLogEventsBatch",
            "logs:CreateLogStream"
          ],
          "Resource": "arn:aws:logs:*"
        }
      ]
    }
  CONFIG
}
