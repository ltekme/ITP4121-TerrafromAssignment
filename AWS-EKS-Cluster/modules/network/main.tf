/*########################################################
Main VPC Block

CIDR: 10.0.0.0/16

########################################################*/
resource "aws_vpc" "Main-VPC" {
  cidr_block = "10.0.0.0/16"

  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "${var.resource-prefix}-Service-VPC"
  }
}


/*########################################################
VPC Internet Gateway

########################################################*/
resource "aws_internet_gateway" "Network-IGW" {
  vpc_id = aws_vpc.Main-VPC.id

  tags = {
    Name = "${aws_vpc.Main-VPC.tags.Name}-IGW"
  }
}


/*########################################################
Elastic IP for NAT Gateway

########################################################*/
resource "aws_eip" "Network-EIP-NAT-AZ_A" {
  // Avalability Zone A - NAT Gateway
  domain = "vpc"

  depends_on = [
    aws_internet_gateway.Network-IGW
  ]

  tags = {
    Name = "${aws_vpc.Main-VPC.tags.Name}-EIP-NATGW-AZ_A"
  }
}

resource "aws_eip" "Network-EIP-NAT-AZ_B" {
  // Avalability Zone B - NAT Gateway
  domain = "vpc"

  depends_on = [
    aws_internet_gateway.Network-IGW
  ]

  tags = {
    Name = "${aws_vpc.Main-VPC.tags.Name}-EIP-NATGW-AZ_B"
  }
}


/*########################################################
VPC NAT Gateway For Private Subnets

########################################################*/
resource "aws_nat_gateway" "private-AZ_A" {
  // Avalability Zone A - NAT Gateway
  subnet_id     = aws_subnet.public-AZ_A.id
  allocation_id = aws_eip.Network-EIP-NAT-AZ_A.id

  depends_on = [
    aws_internet_gateway.Network-IGW
  ]

  tags = {
    Name = "${aws_vpc.Main-VPC.tags.Name}-NAT_GW-AZ_A"
  }
}

resource "aws_nat_gateway" "private-AZ_B" {
  // Avalability Zone B - NAT Gateway
  subnet_id     = aws_subnet.public-AZ_B.id
  allocation_id = aws_eip.Network-EIP-NAT-AZ_B.id

  depends_on = [
    aws_internet_gateway.Network-IGW
  ]
  tags = {
    Name = "${aws_vpc.Main-VPC.tags.Name}-NAT_GW-AZ_B"
  }
}

/*########################################################
Route Tables

Public Route Table:
    Subnets: Public subnet in AZ A & B
    Routes:
        0.0.0.0/0 -> IGW

Private Route Table:
    AZ A:
        Subnets: Private subnets in AZ A
        Routes:
            0.0.0.0 -> NAT Gateway in AZ A

    AZ B:
        Subnets: Private subnets in AZ B
        Routes:
            0.0.0.0 -> NAT Gateway in AZ B

########################################################*/
resource "aws_route_table" "public-Route_Table" {
  // public subnets
  vpc_id = aws_vpc.Main-VPC.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.Network-IGW.id
  }

  tags = {
    Name = "${aws_vpc.Main-VPC.tags.Name}-Public-RTB"
  }
}

resource "aws_route_table" "private-AZ_A-Route_Table" {
  // private subnets in availability zone A
  vpc_id = aws_vpc.Main-VPC.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.private-AZ_A.id
  }

  tags = {
    Name = "${aws_vpc.Main-VPC.tags.Name}-Private-RTB-AZ_A"
  }
}

resource "aws_route_table" "private-AZ_B-Route_Table" {
  // private subnets in availability zone B
  vpc_id = aws_vpc.Main-VPC.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.private-AZ_B.id
  }

  tags = {
    Name = "${aws_vpc.Main-VPC.tags.Name}-Private-RTB-AZ_B"
  }
}


/*########################################################
Public Route Tables Associations

########################################################*/
resource "aws_route_table_association" "public-AZ_A-RTB-Association" {
  // subnet in availability zone A
  subnet_id      = aws_subnet.public-AZ_A.id
  route_table_id = aws_route_table.public-Route_Table.id
}

resource "aws_route_table_association" "public-AZ_B-RTB-Association" {
  // subnet in availability zone B
  subnet_id      = aws_subnet.public-AZ_B.id
  route_table_id = aws_route_table.public-Route_Table.id
}


/*########################################################
Private Route Tables Associations

########################################################*/
resource "aws_route_table_association" "private-AZ_A-RTB-Association" {
  // subnet in availability zone A
  subnet_id      = aws_subnet.private-AZ_A.id
  route_table_id = aws_route_table.private-AZ_A-Route_Table.id
}


resource "aws_route_table_association" "private-AZ_B-RTB-Association" {
  // subnet in availability zone B
  subnet_id      = aws_subnet.private-AZ_B.id
  route_table_id = aws_route_table.private-AZ_B-Route_Table.id
}
