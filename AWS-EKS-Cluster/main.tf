module "network" {
  source           = "./modules/network"
  resource-prefix  = var.resource-prefix
  aws-region       = var.aws-region
  eks-cluster-name = ""
}
