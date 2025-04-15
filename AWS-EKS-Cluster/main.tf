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

  role-arn      = var.cluster-role-arn
  node-role-arn = var.cluster-node-role-arn

}

module "database" {
  source        = "./modules/database"
  database-name = var.resource-prefix

  master-username = "admin"
  master-password = "admin"

  vpc-id = module.network.vpc.id
  subnets = [
    module.network.public-subnet-1.id,
    module.network.public-subnet-2.id,
  ]

  sg-ingress-blocks = ["0.0.0.0/0"]
}
