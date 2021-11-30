data "aws_iam_policy_document" "assume_role" {
  # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
    effect = "Allow"
  }
}

data "aws_iam_policy_document" "allow_describe_regions" {
  statement {
    actions = ["ec2:DescribeRegions"] # リージョン一覧を取得
    resources = ["*"]
    effect = "Allow"
  }
}

resource "aws_iam_role" "startups_note_assume_role" {
  # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role
  name = "startups-note-describe-regions-for-ec2"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
  max_session_duration = 3600 # 1h
}

resource "aws_iam_policy" "startups_note_policy" {
  # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy
  name = "startups-note-describe-regions-for-ec2"
  policy = data.aws_iam_policy_document.allow_describe_regions.json
}

resource "aws_iam_role_policy_attachment" "startups-note" {
  # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment
  role = aws_iam_role.startups_note_assume_role.name
  policy_arn = aws_iam_policy.startups_note_policy.arn
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