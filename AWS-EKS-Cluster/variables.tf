variable "resource-prefix" {
  description = "prefix for each prefix"
  type        = string
}

variable "aws-region" {
  description = "AWS Region code to deploy the resources in"
  type        = string
}

variable "eks-cluster-access-role-arn" {
  description = "The role used to access this cluster"
  type        = string
}
