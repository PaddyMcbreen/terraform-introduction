// terraform connection:

terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.26.0"
    }
  }
}

provider "aws" {
  region = "eu-west-2"
}


// main vpc creation

resource "aws_vpc" "main-vpc" {
  
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "main-vpc"
  }
}


# //public subnet creations *3

resource "aws_subnet" "public-subnet-1" {
  vpc_id     = aws_vpc.main-vpc.id
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "public-subnet-1"
  }
}


resource "aws_subnet" "public-subnet-2" {
  vpc_id     = aws_vpc.main-vpc.id
  cidr_block = "10.0.4.0/24"
  availability_zone = "eu-west-2b"

  tags = {
    Name = "public-subnet-2"
  }
}


resource "aws_subnet" "public-subnet-3" {
  vpc_id     = aws_vpc.main-vpc.id
  cidr_block = "10.0.6.0/24"
  availability_zone = "eu-west-2c"

  tags = {
    Name = "public-subnet-3"
  }
}


# // private subnets *3

resource "aws_subnet" "private-subnet-1" {
  vpc_id     = aws_vpc.main-vpc.id
  cidr_block = "10.0.8.0/24"
  availability_zone = "eu-west-2a"

  tags = {
    Name = "private-subnet-1"
  }
}


resource "aws_subnet" "private-subnet-2" {
  vpc_id     = aws_vpc.main-vpc.id
  cidr_block = "10.0.10.0/24"
  availability_zone = "eu-west-2b"

  tags = {
    Name = "private-subnet-2"
  }
}


resource "aws_subnet" "private-subnet-3" {
  vpc_id     = aws_vpc.main-vpc.id
  cidr_block = "10.0.12.0/24"
  availability_zone = "eu-west-2c"

  tags = {
    Name = "private-subnet-3"
  }
}



# // internet gateway:

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main-vpc.id

  tags = {
    Name = "internet-gateway"
  }
}


# // route table:

resource "aws_route_table" "route-table" {
  vpc_id = aws_vpc.main-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "route-table"
  }
}

// route table associations:

resource "aws_route_table_association" "route-a" {
  subnet_id      = aws_subnet.public-subnet-1.id
  route_table_id = aws_route_table.route-table.id
}

resource "aws_route_table_association" "route-b" {
  subnet_id      = aws_subnet.public-subnet-2.id
  route_table_id = aws_route_table.route-table.id
}

resource "aws_route_table_association" "route-c" {
  subnet_id      = aws_subnet.public-subnet-3.id
  route_table_id = aws_route_table.route-table.id
}

// working code