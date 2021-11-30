module "http_sg" {
  # source = "./modules/security_group" # Module directory  does not exist or cannot be read.
  source = "./modules"
  name = "http-sg"
  vpc_id = aws_vpc.main.id
  port = 80
  cidr_blocks = ["0.0.0.0/0"]
}