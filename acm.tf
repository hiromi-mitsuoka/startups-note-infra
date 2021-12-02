# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate
resource "aws_acm_certificate" "startups_note" {
  domain_name = aws_route53_record.startups_note.name
  subject_alternative_names = []
  validation_method = "DNS" # DNS検証

  # # リソース作成してからリソース削除、SSL証明書の再作成時のサービス影響を最小化
  lifecycle {
    create_before_destroy = true
  }
}

# SSL証明書の検証完了まで待機
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate_validation
resource "aws_acm_certificate_validation" "startups_note" {
  certificate_arn = aws_acm_certificate.startups_note.arn
  # provider 3.0.0 以降は記述が変わる
  validation_record_fqdns = [for record in aws_route53_record.startups_note_certificate : record.fqdn]
  # validation_record_fqdns = [aws_route53_record.startups_note_certificate.fqdn]

  # apply時にSSL証明書の検証が完了するまで待機する
  # 実際に何かのリソースを作るわけではない

  # Note: 下記記事の通り、初回apply時、検証が間に合わず、2回目のapplyで成功した
  # https://qiita.com/pokotyan/items/6a00b5cdfe8811b4c832
}