resource "aws_vpc" "lms-vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "lms-vpc"
  }
}
resource "aws_subnet" "lms-web-subnet" {
  vpc_id     = aws_vpc.lms-vpc.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = "true"

  tags = {
    Name = "lms-web-subnet"
  }
}
resource "aws_subnet" "lms-api-subnet" {
  vpc_id     = aws_vpc.lms-vpc.id
  cidr_block = "10.0.2.0/24"
  map_public_ip_on_launch = "true"

  tags = {
    Name = "lms-api-subnet"
  }
}
resource "aws_subnet" "lms-db-subnet" {
  vpc_id     = aws_vpc.lms-vpc.id
  cidr_block = "10.0.3.0/24"

  tags = {
    Name = "lms-db-subnet"
  }
}
resource "aws_internet_gateway" "lms-igw" {
  vpc_id = aws_vpc.lms-vpc.id

  tags = {
    Name = "lms-igw"
  }
}
resource "aws_route_table" "lms-web-rtb" {
  vpc_id = aws_vpc.lms-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.lms-igw.id
  }

  tags = {
    Name = "lms-web-rtb"
  }
}
resource "aws_route_table" "lms-db-rtb" {
  vpc_id = aws_vpc.lms-vpc.id

  tags = {
    Name = "lms-db-rtb"
  }
}
resource "aws_route_table_association" "lms-web-assc" {
  subnet_id      = aws_subnet.lms-web-subnet.id
  route_table_id = aws_route_table.lms-web-rtb.id
}
resource "aws_route_table_association" "lms-api-assc" {
  subnet_id      = aws_subnet.lms-api-subnet.id
  route_table_id = aws_route_table.lms-web-rtb.id
}
resource "aws_route_table_association" "lms-db-assc" {
  subnet_id      = aws_subnet.lms-db-subnet.id
  route_table_id = aws_route_table.lms-db-rtb.id
}
resource "aws_network_acl" "lms-web-nacl" {
  vpc_id = aws_vpc.lms-vpc.id

  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 65535
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 65535
  }

  tags = {
    Name = "lms-web-nacl"
  }
}

resource "aws_network_acl" "lms-api-nacl" {
  vpc_id = aws_vpc.lms-vpc.id

  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 65535
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 65535
  }

  tags = {
    Name = "lms-api-nacl"
  }
}

resource "aws_network_acl" "lms-db-nacl" {
  vpc_id = aws_vpc.lms-vpc.id

  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 65535
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 65535
  }

  tags = {
    Name = "lms-db-nacl"
  }
}

resource "aws_network_acl_association" "lms-web-nacl-asscn" {
  network_acl_id = aws_network_acl.lms-web-nacl.id
  subnet_id      = aws_subnet.lms-web-subnet.id
}

resource "aws_network_acl_association" "lms-api-nacl-asscn" {
  network_acl_id = aws_network_acl.lms-api-nacl.id
  subnet_id      = aws_subnet.lms-api-subnet.id
}

resource "aws_network_acl_association" "lms-db-nacl-asscn" {
  network_acl_id = aws_network_acl.lms-db-nacl.id
  subnet_id      = aws_subnet.lms-db-subnet.id
}
#security group

resource "aws_security_group" "lms-web-sg" {
  name        = "lms-web-sg"
  description = "Allow SSH & HTTP Traffic"
  vpc_id      = aws_vpc.lms-vpc.id

  tags = {
    Name = "lms-web-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "lms-web-sg-ingress-ssh" {
  security_group_id = aws_security_group.lms-web-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_ingress_rule" "lms-web-sg-ingress-http" {
  security_group_id = aws_security_group.lms-web-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_egress_rule" "lms-web-sg-egress" {
  security_group_id = aws_security_group.lms-web-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}
