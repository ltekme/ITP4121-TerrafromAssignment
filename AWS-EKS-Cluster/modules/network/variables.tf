variable "resource-prefix" {
  description = "The prefix for resources"
  type        = string
}

variable "aws-region" {
  description = "AWS Region code to deploy the resources in"
  type        = string
}

variable "eks-cluster-name" {
  description = "The EKS Cluster Name"
  type        = string
}
