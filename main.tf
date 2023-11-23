// Terraform connection
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.26.0"
    }
  }
}

provider "aws" {
  region = "eu-west-2"
}



// Main VPC creation
resource "aws_vpc" "main-vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "main-vpc"
  }
}


// Public subnet creations
resource "aws_subnet" "public-subnets" {
  vpc_id = aws_vpc.main-vpc.id
  map_public_ip_on_launch = true
  count  = var.public-subnet-count

  cidr_block       = "10.0.${count.index * 5}.0/26"
  availability_zone = "eu-west-2${element(["a", "b", "c"], count.index)}"

  tags = {
    Name = "public-subnet-${count.index + 1}"
  }
}


// Private subnet creations
resource "aws_subnet" "private-subnets" {
  vpc_id = aws_vpc.main-vpc.id
  count  = 3

  cidr_block       = "10.0.${count.index * 5 + 128}.0/26"
  availability_zone = "eu-west-2${element(["a", "b", "c"], count.index)}"

  tags = {
    Name = "private-subnet-${count.index + 1}"
  }
}


// Internet gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main-vpc.id

  tags = {
    Name = "internet-gateway"
  }
}


// Public route table
resource "aws_route_table" "public-route-table" {
  vpc_id = aws_vpc.main-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "public-route-table"
  }
}


// Private route tables
resource "aws_route_table" "private-route-table" {
  count = 3

  vpc_id = aws_vpc.main-vpc.id

  tags = {
    Name = "private-route-table-${count.index + 1}"
  }
}


// Route table associations for public subnets
resource "aws_route_table_association" "public-route" {
  count = 3

  subnet_id      = aws_subnet.public-subnets[count.index].id
  route_table_id = aws_route_table.public-route-table.id
}


// Route table associations for private subnets
resource "aws_route_table_association" "private-route" {
  count = 3

  subnet_id      = aws_subnet.private-subnets[count.index].id
  route_table_id = aws_route_table.private-route-table[count.index].id
}

