// Main VPC creation
resource "aws_vpc" "main-vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "main-vpc"
  }
}

// Public subnet creations
resource "aws_subnet" "public-subnets" {
  vpc_id                  = aws_vpc.main-vpc.id
  map_public_ip_on_launch = true
  count                   = var.public-subnet-count

  cidr_block        = "10.0.${count.index * 5}.0/26"
  availability_zone = "eu-west-2${element(["a", "b", "c"], count.index)}"

  tags = {
    Name = "public-subnet-eu-west-2${element(["a", "b", "c"], count.index)}-${count.index + 1}"
  }
}


// Private subnet creations
resource "aws_subnet" "private-subnets" {
  vpc_id = aws_vpc.main-vpc.id
  count  = var.private-subnet-count

  cidr_block        = "10.0.${count.index * 5 + 128}.0/26"
  availability_zone = "eu-west-2${element(["a", "b", "c"], count.index)}"

  tags = {
    Name = "private-subnet-eu-west-2${element(["a", "b", "c"], count.index)}-${count.index + 1}"
  }
}


// Internet gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main-vpc.id

  tags = {
    Name = "internet-gateway"
  }
}

#  Nat gateway
resource "aws_nat_gateway" "ngw" {
  count = 1

  connectivity_type = "private"
  subnet_id         = aws_subnet.private-subnets[count.index].id

  tags = {
    Name = "nat-internet-gateway"
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
  count  = var.private-subnet-count
  vpc_id = aws_vpc.main-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.ngw[count.index - count.index].id
  }

  tags = {
    Name = "private-route-table-eu-west-2${element(["a", "b", "c"], count.index)}-${count.index + 1}"
  }
}


// Route table associations for public subnets
resource "aws_route_table_association" "public-route" {
  count = var.public-subnet-count

  subnet_id      = aws_subnet.public-subnets[count.index].id
  route_table_id = aws_route_table.public-route-table.id
}


// Route table associations for private subnets
resource "aws_route_table_association" "private-route" {
  count = var.private-subnet-count

  subnet_id      = aws_subnet.private-subnets[count.index].id
  route_table_id = aws_route_table.private-route-table[count.index].id
}


// modules vpc from terraform docs

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "terra-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["eu-west-2a", "eu-west-2b", "eu-west-2c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway = true
  enable_vpn_gateway = true

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

