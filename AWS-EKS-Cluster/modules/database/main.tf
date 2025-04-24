resource "aws_db_instance" "default" {
  allocated_storage = 10

  engine         = "postgres"
  engine_version = "17.2"
  instance_class = "db.t3.micro"

  username = var.master-username
  password = var.master-password

  availability_zone   = var.availability_zone
  publicly_accessible = true

  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.group1.name

  skip_final_snapshot = true // required to destroy
}

resource "aws_security_group" "rds_sg" {
  name        = "Rule for rds-${var.database-name}"
  description = "Rule for rds-${var.database-name}"
  vpc_id      = var.vpc-id
}

resource "aws_vpc_security_group_ingress_rule" "db-ingress" {
  for_each          = toset(var.sg-ingress-blocks)
  security_group_id = aws_security_group.rds_sg.id
  cidr_ipv4         = each.key
  from_port         = 5432
  ip_protocol       = "tcp"
  to_port           = 5432
}

resource "aws_vpc_security_group_egress_rule" "db-egress" {
  security_group_id = aws_security_group.rds_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}


resource "aws_db_subnet_group" "group1" {
  name       = lower("${var.database-name}-subnet-group")
  subnet_ids = var.subnets

  tags = {
    Name = lower("${var.database-name}-subnet-group")
  }
}

