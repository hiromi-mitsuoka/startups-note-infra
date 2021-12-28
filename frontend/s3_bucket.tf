# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket
resource "aws_s3_bucket" "front_alb_accesslog_bucket" {
  bucket = "startups-note-front-alblog"

  lifecycle_rule {
    enabled = true # Enable versioning

    expiration {
      days = "7" # TODO: Follow the law when fully operation.
    }
  }

  force_destroy = true # TODO: Set to false during fully operation.
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy
resource "aws_s3_bucket_policy" "front_alb_accesslog" {
  bucket = aws_s3_bucket.front_alb_accesslog_bucket.id
  policy = data.aws_iam_policy_document.front_alb_accesslog.json
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document
data "aws_iam_policy_document" "front_alb_accesslog" {
  statement {
    effect = "Allow"
    actions = ["s3:PutObject"]
    resources = ["arn:aws:s3:::${aws_s3_bucket.front_alb_accesslog_bucket.id}/*"]

    principals {
      type = "AWS"
      # https://qiita.com/stakakey/items/ca54f8c7bba6723c7eed
      identifiers = [data.aws_elb_service_account.main.arn] # ELB Account ID（582318560864） of Tokyo-region（ap-northeast-1）
    }
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/billing_service_account
data "aws_elb_service_account" "main" {}