#Cria a VPC
resource "aws_vpc" "documentacao_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "documentacao_vpc"
  }

}

#Cria o Internet Gateway
resource "aws_internet_gateway" "documentacao_igw" {
  vpc_id = aws_vpc.documentacao_vpc.id

  tags = {
    Name = "documentacao_igw"
  }
}

#Cria um IP elástico para a VPC
resource "aws_eip" "documentacao_eip" {
  domain = "vpc"

  tags = {
    Name = "documentacao_eip"
  }

}


#================================================================================================
#Criação das Subnets 
#================================================================================================

#Subnet pública A
resource "aws_subnet" "documentacao_subnet_publica_A" {
  vpc_id            = aws_vpc.documentacao_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "documentacao_subnet_publica_A"
  }
}

#Subnet pública B
resource "aws_subnet" "documentacao_subnet_publica_B" {
  vpc_id            = aws_vpc.documentacao_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1c"

  tags = {
    Name = "documentacao_subnet_publica_B"
  }
}

#Subnet privada A
resource "aws_subnet" "documentacao_subnet_privada_A" {
  vpc_id            = aws_vpc.documentacao_vpc.id
  cidr_block        = "10.0.10.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "documentacao_subnet_privada_A"
  }
}

#Subnet privada B
resource "aws_subnet" "documentacao_subnet_privada_B" {
  vpc_id            = aws_vpc.documentacao_vpc.id
  cidr_block        = "10.0.11.0/24"
  availability_zone = "us-east-1c"

  tags = {
    Name = "documentacao_subnet_privada_B"
  }
}

#===============================================================================================


#Cria o NAT Gateway e já associa o IP elástico a ele
resource "aws_nat_gateway" "documentacao_nat" {
  allocation_id = aws_eip.documentacao_eip.id
  subnet_id     = aws_subnet.documentacao_subnet_publica_A.id

  tags = {
    Name = "documentacao_nat"
  }

  depends_on = [aws_internet_gateway.documentacao_igw]
}

#===============================================================================================

#Route Table Publica
resource "aws_route_table" "documentacao_route_table_publica" {
  vpc_id = aws_vpc.documentacao_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.documentacao_igw.id
  }
}

#Route Table Privada
resource "aws_route_table" "documentacao_route_table_privada" {
  vpc_id = aws_vpc.documentacao_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.documentacao_nat.id
  }
}

#===============================================================================================

resource "aws_route_table_association" "documentacao_route_table_association_publica_A" {
  subnet_id      = aws_subnet.documentacao_subnet_publica_A.id
  route_table_id = aws_route_table.documentacao_route_table_publica.id
}

resource "aws_route_table_association" "documentacao_route_table_association_publica_B" {
  subnet_id      = aws_subnet.documentacao_subnet_publica_B.id
  route_table_id = aws_route_table.documentacao_route_table_publica.id
}

resource "aws_route_table_association" "documentacao_route_table_association_privada_A" {
  subnet_id      = aws_subnet.documentacao_subnet_privada_A.id
  route_table_id = aws_route_table.documentacao_route_table_privada.id
}

resource "aws_route_table_association" "documentacao_route_table_association_privada_B" {
  subnet_id      = aws_subnet.documentacao_subnet_privada_B.id
  route_table_id = aws_route_table.documentacao_route_table_privada.id
}