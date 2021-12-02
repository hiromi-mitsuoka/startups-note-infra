# data "aws_region" "current" {}

# data "aws_caller_identity" "current" {}

# # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticsearch_domain
# resource "aws_elasticsearch_domain" "startups_note" {
#   domain_name = "startups-note"
#   elasticsearch_version "7.10" # Dockerfile-elasticsearch

#   cluster_config {
#     instance_type = "t2.micro.elasticsearch"
#   }

#   access_policies = <<POLICY
#     {
#       "Version": "2012-10-17"
#       "Statement": [
#         {
#           "Action": "es:*"
#           "Principal": {
#             "AWS": "*"
#           },
#           "Effect": "Allow"
#           "Resource": "arn:aws:es:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:domain/startups_note/*",
#         }
#       ]
#     }
#   POLICY
# }