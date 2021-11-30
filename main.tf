provider "aws" {
  # https://registry.terraform.io/providers/hashicorp/aws/latest/docs
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region = var.aws_region
}