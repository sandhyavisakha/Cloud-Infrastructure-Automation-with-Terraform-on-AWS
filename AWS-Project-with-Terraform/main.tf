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

resource "aws_security_group" "mysg" {
  name        = "websg"
  vpc_id      = aws_vpc.myvpctf.id
  tags = {
    Name = "web-sg"
  }

  ingress {
    description = "HTTP from VPC"
    protocol  = "tcp"
    from_port = 80
    to_port   = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    protocol  = "tcp"
    from_port = 22
    to_port   = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_s3_bucket" "tfbucket" {
  bucket = "my-terraform-bucket-sandhya92"
}

resource "aws_instance" "webserver-1" {
  ami = "ami-0c7217cdde317cfec"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.mysg.id]
  subnet_id = aws_subnet.subnet-1.id
  user_data = base64encode(file("userdata1.sh"))
}

resource "aws_instance" "webserver-2" {
  ami = "ami-0c7217cdde317cfec"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.mysg.id]
  subnet_id = aws_subnet.subnet-2.id
  user_data = base64encode(file("userdata2.sh"))
}