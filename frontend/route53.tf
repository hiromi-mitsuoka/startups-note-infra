# ホストゾーン : DNSレコードを束ねるリソース、
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone
data "aws_route53_zone" "front" {
  name = var.domain
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record
resource "aws_route53_record" "front" {
  zone_id = data.aws_route53_zone.front.zone_id
  name = data.aws_route53_zone.front.name
  type = "A"

  alias {
    name = aws_lb.front.dns_name
    zone_id = aws_lb.front.zone_id
    evaluate_target_health = true
  }
}

# DNS records for SSL certificate verification.
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate_validation
resource "aws_route53_record" "front_certificate" {
  for_each = {
    for dvo in aws_acm_certificate.front.domain_validation_options : dvo.domain_name => {
      name = dvo.resource_record_name
      type = dvo.resource_record_type
      record = dvo.resource_record_value
    }
  }

  name = each.value.name
  type = each.value.type
  records = [each.value.record]
  zone_id = data.aws_route53_zone.front.id
  ttl = 60
}