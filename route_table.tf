# public

# public route table は1つ
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "startups-note-public-route-table"
  }
}

# public - internet(0.0.0.0/0)
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route
resource "aws_route" "public" {
  route_table_id = aws_route_table.public.id
  gateway_id = aws_internet_gateway.main.id
  destination_cidr_block = "0.0.0.0/0"
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association
resource "aws_route_table_association" "public_1a" {
  subnet_id = aws_subnet.public_1a.id
  route_table_id = aws_route_table.public.id # デフォルトルートテーブルの利用はアンチパターンのため、関連づけ
}

resource "aws_route_table_association" "public_1c" {
  subnet_id = aws_subnet.public_1c.id
  route_table_id = aws_route_table.public.id # デフォルトルートテーブルの利用はアンチパターンのため、関連づけ
}


# private

resource "aws_route_table" "private_1a" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "startups-note-private-route-table-1a"
  }
}

resource "aws_route_table_association" "private_1a" {
  subnet_id = aws_subnet.private_1a.id
  route_table_id = aws_route_table.private_1a.id
}

# private network - internet
resource "aws_route" "private_1a" {
  route_table_id = aws_route_table.private_1a.id
  nat_gateway_id = aws_nat_gateway.nat_gateway_1a.id # public時は、gateway_id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route_table" "private_1c" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "startups-note-private-route-table-1c"
  }
}

resource "aws_route_table_association" "private_1c" {
  subnet_id = aws_subnet.private_1c.id
  route_table_id = aws_route_table.private_1c.id
}

resource "aws_route" "private_1c" {
  route_table_id = aws_route_table.private_1c.id
  nat_gateway_id = aws_nat_gateway.nat_gateway_1c.id # public時は、gateway_id
  destination_cidr_block = "0.0.0.0/0"
}

