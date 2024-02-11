resource "aws_vpc" "myvpctf" {
  cidr_block = var.vpc-cidr
}

resource "aws_subnet" "subnet-1" {
  vpc_id = aws_vpc.myvpctf.id
  cidr_block = var.sub1-cidr
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "subnet-2" {
  vpc_id = aws_vpc.myvpctf.id
  cidr_block = var.sub2-cidr
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "igwtf" {
  vpc_id = aws_vpc.myvpctf.id
}

resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.myvpctf.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igwtf.id
  }
}

resource "aws_route_table_association" "rta1" {
  subnet_id = aws_subnet.subnet-1.id
  route_table_id = aws_route_table.rt.id
}

resource "aws_route_table_association" "rta2" {
  subnet_id = aws_subnet.subnet-2.id
  route_table_id = aws_route_table.rt.id
}