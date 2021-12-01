module "startups_note_describe_regions_for_ec2" {
  source = "./modules/iam_role"
  name = "startups-note-describe-regions-for-ec2"
  identifier = "ec2.amazonaws.com"
  policy = data.aws_iam_policy_document.allow_describe_regions.json
}

data "aws_iam_policy_document" "allow_describe_regions" {
  statement {
    actions = ["ec2:DescribeRegions"] # リージョン一覧を取得
    resources = ["*"]
    effect = "Allow"
  }
}