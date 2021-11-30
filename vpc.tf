resource "aws_vpc" "main" {
  # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true # VPC内のリソースにパブリックDNSホスト名を自動割り当て

  # Leave default
  instance_tenancy = "default" # 共有テナンシー
  enable_dns_support = true # AWSのDNSサーバーによる名前解決を有効
  enable_classiclink = false
  assign_generated_ipv6_cidr_block = false

  tags = {
    Name = "startups-note-vpc"
  }
}