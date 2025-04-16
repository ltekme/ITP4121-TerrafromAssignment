provider "aws" {
  default_tags {
    tags = {
      Created_by = "Terrafrom"
      Project    = var.resource-prefix
    }
  }
  region = var.aws-region
}

module "network" {
  source           = "./modules/network"
  resource-prefix  = var.resource-prefix
  aws-region       = var.aws-region
  eks-cluster-name = var.resource-prefix
}

module "eks-cluster" {
  source = "./modules/cluster"
  name   = var.resource-prefix

  vpc-id = module.network.vpc.id
  subnet-ids = [
    module.network.isolated-subnet-1.id,
    module.network.isolated-subnet-2.id,
  ]
  node-subnet-ids = [
    module.network.private-subnet-1.id,
    module.network.private-subnet-2.id,
  ]

  role-arn                = var.eks-cluster-role-arn
  node-role-arn           = var.eks-cluster-node-role-arn
  cluster-access-role-arn = var.eks-cluster-access-role-arn
}

module "database" {
  source        = "./modules/database"
  database-name = var.resource-prefix

  master-username = local.rds-master-username
  master-password = local.rds-master-password

  availability_zone = "${var.aws-region}a"

  vpc-id = module.network.vpc.id
  subnets = [
    module.network.public-subnet-1.id,
    module.network.public-subnet-2.id,
  ]

  sg-ingress-blocks = ["0.0.0.0/0"]
}
