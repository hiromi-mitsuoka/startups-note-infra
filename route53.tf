# ホストゾーン : DNSレコードを束ねるリソース、
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone
data "aws_route53_zone" "startups_note" {
  name = var.domain
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record
resource "aws_route53_record" "startups_note" {
  zone_id = data.aws_route53_zone.startups_note.zone_id
  name = data.aws_route53_zone.startups_note.name
  type = "A" # Aレコード

  # CNAMEレコード : ドメイン名→CNAMEレコードのドメイン名→IPアドレス
  # ALIASレコード : ドメイン名→IPアドレス、パフォーマンス向上
  alias {
    name = aws_lb.startups_note_alb.dns_name
    zone_id = aws_lb.startups_note_alb.zone_id
    evaluate_target_health = true
  }
}

# SSL証明書検証用DNSレコード
resource "aws_route53_record" "startups_note_certificate" {
  # provider 3.0.0 以降は記述が変わる
  # （https://dev.classmethod.jp/articles/terraform-aws-certificate-validation/）
  # （https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate_validation）
  for_each = {
    # domain_nameを、keyとしたmapタイプに変換
    for dvo in aws_acm_certificate.startups_note.domain_validation_options : dvo.domain_name => {
      name = dvo.resource_record_name
      type = dvo.resource_record_type
      record = dvo.resource_record_value
    }
  }
  # name = aws_acm_certificate.startups_note.domain_validation_options[0].resource_record_name
  # type = aws_acm_certificate.startups_note.domain_validation_options[0].resource_record_type
  # records = [aws_acm_certificate.startups_note.domain_validation_options[0].resource_record_value]

  name = each.value.name
  type = each.value.type
  records = [each.value.record]
  zone_id = data.aws_route53_zone.startups_note.id
  ttl = 60
}