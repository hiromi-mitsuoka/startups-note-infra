module "http_sg" {
  # source = "./modules/security_group" # Module directory  does not exist or cannot be read.
  # Note: modules内で、ディレクトリを分けないと、変数を共有してしまう。
  # Note: sourceはディレクトリを指定（ファイル含まない）
  source = "./modules/security_group"
  name = "http-sg"
  vpc_id = aws_vpc.main.id
  port = 80
  cidr_blocks = ["0.0.0.0/0"]
}

module "https_sg" {
  source = "./modules/security_group"
  name = "https-sg"
  vpc_id = aws_vpc.main.id
  port = 443
  cidr_blocks = ["0.0.0.0/0"]
}

module "http_redirect_sg" {
  source = "./modules/security_group"
  name = "http-redirect-sg"
  vpc_id = aws_vpc.main.id
  port = 8080
  cidr_blocks = ["0.0.0.0/0"]
}

# module "inbound_traffic_sg" {
#   source = "./modules/security_group"
#   name = "inbound-traffic-sg"
#   vpc_id = aws_vpc.main.id
#   port = 5000
#   cidr_blocks = ["0.0.0.0/0"]
# }