module "front_http_sg" {
  source = "./modules/security_group"
  name = "front-http-sg"
  vpc_id = var.vpc_id
  port = 80
  cidr_blocks = ["0.0.0.0/0"]
}

module "front_http_sg_81" {
  source = "./modules/security_group"
  name = "front-http-sg-81"
  vpc_id = var.vpc_id
  port = 81
  cidr_blocks = ["0.0.0.0/0"]
}

module "front_https_sg" {
  source = "./modules/security_group"
  name = "front-https-sg"
  vpc_id = var.vpc_id
  port = 443
  cidr_blocks = ["0.0.0.0/0"]
}

module "front_http_redirect_sg" {
  source = "./modules/security_group"
  name = "front-http-redirect-sg"
  vpc_id = var.vpc_id
  port = 8080
  cidr_blocks = ["0.0.0.0/0"]
}