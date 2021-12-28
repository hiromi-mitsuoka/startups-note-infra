# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate
resource "aws_acm_certificate" "front" {
  domain_name = aws_route53_record.front.name
  subject_alternative_names = []
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate_validation
resource "aws_acm_certificate_validation" "front" {
  certificate_arn = aws_acm_certificate.front.arn
  # provider 3.0.0 以降は記述が変わる
  validation_record_fqdns = [for record in aws_route53_record.front_certificate : record.fqdn]

  # apply時にSSL証明書の検証が完了するまで待機する
  # 実際に何かのリソースを作るわけではない

  # Note: 下記記事の通り、初回apply時、検証が間に合わず、2回目のapplyで成功した
  # https://qiita.com/pokotyan/items/6a00b5cdfe8811b4c832
}