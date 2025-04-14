module "network" {
  source           = "./modules/network"
  resource-prefix  = var.resource-prefix
  aws-region       = var.aws-region
  eks-cluster-name = var.resource-prefix
}

module "eks-cluster" {
  source     = "./modules/cluster"
  name       = var.resource-prefix
  aws-region = var.aws-region

  vpc-id = module.network.vpc.id
  subnet-ids = [
    module.network.subnets.isolate-AZ_A.id,
    module.network.subnets.isolate-AZ_B.id,
  ]
  node-subnet-ids = [
    #  create: unexpected state 'CREATE_FAILED', wanted target 'ACTIVE'. last error: Ec2SubnetInvalidConfiguration: One or more Amazon EC2 Subnets of [] for node group itp4121-1 does not automatically assign public IP addresses to instances launched into it.
    module.network.subnets.private-AZ_A.id,
    module.network.subnets.private-AZ_B.id,
  ]

  role-arn      = var.cluster-role-arn
  node-role-arn = var.cluster-node-role-arn

}
