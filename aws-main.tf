module "aws-eks-cluster" {
  source                      = "./AWS-EKS-Cluster"
  aws-region                  = "us-east-1"
  resource-prefix             = var.aws-project-name
  eks-cluster-access-role-arn = var.aws-eks-cluster-access-role-arn
}

module "aws-eks-deployment" {
  source                  = "./AWS-EKS-Cluster-Deployment"
  ecr-repository          = module.aws-eks-cluster.ecr-repository
  eks-cluster-endpoint    = module.aws-eks-cluster.eks-cluster-endpoint
  eks-cluster-certificate = module.aws-eks-cluster.eks-cluster-certificate
  eks-cluster-token       = module.aws-eks-cluster.eks-cluster-auth-token.token
}
