module "rds-cluster" {
  source = "terraform-aws-modules/rds-aurora/aws"

  name = "${var.prefix}-DB"

  engine         = "aurora-mysql"
  engine_mode    = "provisioned"
  engine_version = "8.0"

  database_name = var.database-name

  master_username                     = var.master-username
  master_password                     = var.master-password
  iam_database_authentication_enabled = false
  manage_master_user_password         = false
  publicly_accessible                 = true

  vpc_id               = aws_vpc.VTC-Service.id
  db_subnet_group_name = aws_db_subnet_group.VTC_Service-MAIN_RDS.name

  security_group_rules = {
    vpc_ingress = {
      cidr_blocks = [
        aws_subnet.VTC_Service-private-AZ_A.cidr_block,
        aws_subnet.VTC_Service-private-AZ_B.cidr_block,
        "0.0.0.0/0" # For Public Access
      ]
    }
  }

  storage_encrypted   = true
  apply_immediately   = true
  skip_final_snapshot = true

  serverlessv2_scaling_configuration = {
    min_capacity = 1
    max_capacity = 2
  }

  instance_class = "db.serverless"
  instances = {
    one = {}
  }
}

resource "aws_db_subnet_group" "group1" {
  name       = lower("${var.prefix}-${var.database-name}-subnet-group")
  subnet_ids = var.subnets

  tags = {
    Name = lower("${var.prefix}-${var.database-name}-subnet-group")
  }
}

