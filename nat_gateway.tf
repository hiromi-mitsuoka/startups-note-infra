# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip
resource "aws_eip" "nat_gateway_1a" {
  vpc = true # Boolean if the EIP is in a VPC or not.
  depends_on = [aws_internet_gateway.main]

  tags = {
    Name = "startups-note-nat-gateway-1a-eip"
  }
}

resource "aws_eip" "nat_gateway_1c" {
  vpc = true
  depends_on = [aws_internet_gateway.main]

  tags = {
    Name = "startups-note-nat-gateway-1c-eip"
  }
}

resource "aws_nat_gateway" "nat_gateway_1a" {
  allocation_id = aws_eip.nat_gateway_1a.id
  subnet_id = aws_subnet.public_1a.id # The Subnet ID of the subnet in which to place the gateway.
  depends_on = [aws_internet_gateway.main]

  tags = {
    Name = "startups-note-nat-gateway-1a"
  }
}

resource "aws_nat_gateway" "nat_gateway_1c" {
  allocation_id = aws_eip.nat_gateway_1c.id
  subnet_id = aws_subnet.public_1c.id # The Subnet ID of the subnet in which to place the gateway.
  depends_on = [aws_internet_gateway.main]

  tags = {
    Name = "startups-note-nat-gateway-1c"
  }
}