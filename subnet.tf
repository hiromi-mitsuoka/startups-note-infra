# public subnets

resource "aws_subnet" "public_1a" {
  # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = true # このサブネットで起動したインスタンスにパブリックIPアドレスを自動割り当て
  availability_zone = "ap-northeast-1a"

  tags = {
    Name = "startups-note-public-subent-1a"
  }
}

resource "aws_subnet" "public_1c" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.2.0/24"
  map_public_ip_on_launch = true
  availability_zone = "ap-northeast-1c"

  tags = {
    Name = "startups-note-public-subent-1c"
  }
}

# private subnets

resource "aws_subnet" "private_1a" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.64.0/24"
  availability_zone = "ap-northeast-1a"

  # Leave default
  map_public_ip_on_launch = false

  tags = {
    Name = "startups-note-private-subent-1a"
  }
}

resource "aws_subnet" "private_1c" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.65.0/24"
  availability_zone = "ap-northeast-1c"

  # Leave default
  map_public_ip_on_launch = false

  tags = {
    Name = "startups-note-private-subent-1c"
  }
}