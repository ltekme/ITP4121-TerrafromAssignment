module "aws-eks-cluster" {
  source                      = "./AWS-EKS-Cluster"
  aws-region                  = "us-east-1"
  resource-prefix             = var.aws-project-name
  eks-cluster-role-arn        = var.aws-eks-cluster-role-arn
  eks-cluster-node-role-arn   = var.aws-eks-cluster-node-role-arn
  eks-cluster-access-role-arn = var.aws-eks-cluster-access-role-arn
}
