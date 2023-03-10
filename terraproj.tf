

terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.56.0"
    }
  }
}

provider "aws" {
  # Configuration options
  region = "us-east-1"
}

resource "aws_vpc" "main" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "mainvpc"
  }
}

resource "aws_subnet" "mainpub" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "publicsub"
  }
}

resource "aws_subnet" "mainpriv" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "privatesub"
  }
}

resource "aws_internet_gateway" "maingw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main_igw"
  }
}

resource "aws_route_table" "mainpriv" {
  vpc_id = aws_vpc.main.id

  #route = []

  tags = {
    Name = "main_priv_rt"
  }
}

resource "aws_route_table" "mainpub" {
  vpc_id = aws_vpc.main.id

  #route = []

  tags = {
    Name = "main_pub_rt"
  }
}

resource "aws_route_table_association" "main_pub" {
  subnet_id      = aws_subnet.mainpub.id
  route_table_id = aws_route_table.mainpub.id
}

resource "aws_route_table_association" "main_priv" {
  subnet_id      = aws_subnet.mainpriv.id
  route_table_id = aws_route_table.mainpriv.id
}

resource "aws_instance" "mainec2" {
  ami           = "ami-006dcf34c09e50022"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.mainpub.id

  tags = {
    Name = "Project_EC2"
  }
}


resource "aws_s3_bucket" "mainbkt" {
  bucket = "my-tf-test-bucket"

  tags = {
    Name        = "My main bucket"
    Environment = "DevOps"
  }
}