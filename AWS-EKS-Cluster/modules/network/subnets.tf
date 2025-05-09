/*########################################################
Private Subnets

10.0.0.0/24 -> Avalability Zone A
10.0.1.0/24 -> Avalability Zone B

########################################################*/
resource "aws_subnet" "private-AZ_A" {
  // Avalability Zone A
  vpc_id            = aws_vpc.Main-VPC.id
  availability_zone = "${var.aws-region}a"
  cidr_block        = "10.0.0.0/24"

  tags = {
    Name                                            = "${aws_vpc.Main-VPC.tags.Name}-private-AZ_A"
    "kubernetes.io/role/internal-elb"               = 1
    "kubernetes.io/cluster/${var.eks-cluster-name}" = "shared"
  }
}

resource "aws_subnet" "private-AZ_B" {
  // Avalability Zone B
  vpc_id            = aws_vpc.Main-VPC.id
  availability_zone = "${var.aws-region}b"
  cidr_block        = "10.0.1.0/24"

  tags = {
    Name                                            = "${aws_vpc.Main-VPC.tags.Name}-private-AZ_B"
    "kubernetes.io/role/internal-elb"               = 1
    "kubernetes.io/cluster/${var.eks-cluster-name}" = "shared"
  }
}


/*########################################################
Public Subnets

10.0.2.0/24 -> Avalability Zone A
10.0.3.0/24 -> Avalability Zone B

########################################################*/
resource "aws_subnet" "public-AZ_A" {
  // Avalability Zone A
  vpc_id            = aws_vpc.Main-VPC.id
  availability_zone = "${var.aws-region}a"
  cidr_block        = "10.0.2.0/24"

  tags = {
    Name                                            = "${aws_vpc.Main-VPC.tags.Name}-public-AZ_A"
    "kubernetes.io/role/elb"                        = 1
    "kubernetes.io/cluster/${var.eks-cluster-name}" = "shared"
  }
}

resource "aws_subnet" "public-AZ_B" {
  // Avalability Zone B
  vpc_id            = aws_vpc.Main-VPC.id
  availability_zone = "${var.aws-region}b"
  cidr_block        = "10.0.3.0/24"

  tags = {
    Name                                            = "${aws_vpc.Main-VPC.tags.Name}-public-AZ_B"
    "kubernetes.io/role/elb"                        = 1
    "kubernetes.io/cluster/${var.eks-cluster-name}" = "shared"
  }
}

/*########################################################
Isolated Subnets

10.0.4.0/24 -> Avalability Zone A
10.0.5.0/24 -> Avalability Zone B

########################################################*/
resource "aws_subnet" "isolate-AZ_A" {
  // Avalability Zone A
  vpc_id            = aws_vpc.Main-VPC.id
  availability_zone = "${var.aws-region}a"
  cidr_block        = "10.0.4.0/24"

  tags = {
    Name = "${aws_vpc.Main-VPC.tags.Name}-isolated-AZ_A"
  }
}

resource "aws_subnet" "isolate-AZ_B" {
  // Avalability Zone B
  vpc_id            = aws_vpc.Main-VPC.id
  availability_zone = "${var.aws-region}b"
  cidr_block        = "10.0.5.0/24"

  tags = {
    Name = "${aws_vpc.Main-VPC.tags.Name}-isolated-AZ_B"
  }
}
