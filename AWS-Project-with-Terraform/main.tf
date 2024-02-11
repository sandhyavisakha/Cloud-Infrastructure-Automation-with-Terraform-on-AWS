resource "aws_vpc" "myvpctf" {
  cidr_block = var.vpc-cidr
}

resource "aws_subnet" "subnet-1" {
  vpc_id = aws_vpc.myvpctf.id
  cidr_block = var.sub1-cidr
}
