/*########################################################
AWS Terraform Provider

Default Tags on resources:
    Created_by: "Terrafrom"
    Project:    var.project_name

########################################################*/
provider "aws" {
  default_tags {
    tags = {
      Created_by = "Terrafrom"
      Project    = var.project-name
    }
  }
  region = var.aws-region
}


module "aws-eks-cluster" {
  count                 = var.deploy-aws ? 1 : 0
  source                = "./AWS-EKS-Cluster"
  aws-region            = "us-east-1"
  resource-prefix       = var.project-name
  cluster-role-arn      = var.aws-eks-cluster-role-arn
  cluster-node-role-arn = var.aws-eks-cluster-node-role-arn
}

