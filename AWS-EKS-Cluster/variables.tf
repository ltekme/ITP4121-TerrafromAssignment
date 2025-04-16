variable "resource-prefix" {
  description = "prefix for each prefix"
  type        = string
}

variable "aws-region" {
  description = "AWS Region code to deploy the resources in"
  type        = string
}

variable "eks-cluster-role-arn" {
  description = "The role this cluster use"
  type        = string
}

variable "eks-cluster-node-role-arn" {
  description = "The role this cluster use for workers"
  type        = string
}

variable "eks-cluster-access-role-arn" {
  description = "The role used to access this cluster"
  type        = string
}
