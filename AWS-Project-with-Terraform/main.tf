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
