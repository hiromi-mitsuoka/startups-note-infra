# private bucket

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket
resource "aws_s3_bucket" "private" {
  bucket = "startups-note-private-bucket" # 一意

  # https://docs.aws.amazon.com/AmazonS3/latest/userguide/acl-overview.html#canned-acl
  acl = "private" # 作成したAWSアカウントのみアクセス可能

  # https://docs.aws.amazon.com/AmazonS3/latest/userguide/Versioning.html
  versioning {
    enabled = true
  }

  # https://docs.aws.amazon.com/AmazonS3/latest/userguide/bucket-encryption.html
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256" # SSE-S3
      }
    }
  }

  force_destroy = true # TODO: 本格運用時はfalse
}

resource "aws_s3_bucket_public_access_block" "private" {
  # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block
  bucket = aws_s3_bucket.private.id
  block_public_acls = true
  block_public_policy = true
  ignore_public_acls = true
  restrict_public_buckets = true
}


# public bucket

resource "aws_s3_bucket" "public" {
  bucket = "startups-note-public-bucket"
  acl = "public-read" # 作成したAWSアカウントアクセス可能 & インターネットから読み込み可能

  cors_rule {
    allowed_origins = ["https://${var.domain}"]
    allowed_methods = ["GET"]
    allowed_headers = ["*"]
    max_age_seconds = 3000
  }

  force_destroy = true # TODO: 本格運用時はfalse
}


# log bucket

resource "aws_s3_bucket" "alb_log" {
  bucket = "startups-note-alb-lob-bucket"

  lifecycle_rule {
    enabled = true # Enable versioning

    expiration {
      days = "7" # TODO: 本格運用時は、法にのっとる
    }
  }

  force_destroy = true # TODO: 本格運用時はfalse
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy
resource "aws_s3_bucket_policy" "alb_log" {
  bucket = aws_s3_bucket.alb_log.id
  policy = data.aws_iam_policy_document.alb_log.json
}

data "aws_iam_policy_document" "alb_log" {
  statement {
    effect = "Allow"
    actions = ["s3:PutObject"]
    resources = ["arn:aws:s3:::${aws_s3_bucket.alb_log.id}/*"]

    principals {
      type = "AWS" # AWSリソース対象
      # NOTE: 記述方法変えたら一旦applyできた（https://qiita.com/stakakey/items/ca54f8c7bba6723c7eed）
      identifiers = [data.aws_elb_service_account.main.arn] # 東京リージョン（ap-northeast-1）のELBアカウントID（582318560864）
    }
  }
}

data "aws_elb_service_account" "main" {}