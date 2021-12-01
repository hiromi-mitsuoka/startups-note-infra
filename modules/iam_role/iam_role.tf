variable "name" {}
variable "policy" {}
variable "identifier" {}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role
resource "aws_iam_role" "default" {
  name = var.name
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
  max_session_duration = 3600 # 1h
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document
data "aws_iam_policy_document" "assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type = "Service"
      identifiers = [var.identifier]
    }
    effect = "Allow"
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy
resource "aws_iam_policy" "default" {
  name = var.name
  policy = var.policy
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment
resource "aws_iam_role_policy_attachment" "startups-note" {
  role = aws_iam_role.default.name
  policy_arn = aws_iam_policy.default.arn
}

output "iam_role_arn" {
  value = aws_iam_role.default.arn
}

output "iam_role_name" {
  value = aws_iam_role.default.name
}


# data.aws_iam_policy_document.source_json_example.json will evaluate to:

# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Sid": "",
#       "Effect": "Allow",
#       "Action": "ec2:*",
#       "Resource": "*"
#     },
#     {
#       "Sid": "SidToOverride",
#       "Effect": "Allow",
#       "Action": "s3:*",
#       "Resource": [
#         "arn:aws:s3:::somebucket/*",
#         "arn:aws:s3:::somebucket"
#       ]
#     }
#   ]
# }