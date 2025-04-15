module "rds-cluster" {
  source = "terraform-aws-modules/rds-aurora/aws"

  name = var.database-name

  engine         = "aurora-postgresql"
  engine_mode    = "provisioned"
  engine_version = "14.5"

  master_username = var.master-username
  master_password = var.master-password

  iam_database_authentication_enabled = false
  manage_master_user_password         = false
  publicly_accessible                 = true

  vpc_id               = var.vpc-id
  db_subnet_group_name = aws_db_subnet_group.group1.name

  security_group_rules = {
    vpc_ingress = {
      cidr_blocks = var.sg-ingress-blocks
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
  name       = lower("${var.database-name}-subnet-group")
  subnet_ids = var.subnets

  tags = {
    Name = lower("${var.database-name}-subnet-group")
  }
}

