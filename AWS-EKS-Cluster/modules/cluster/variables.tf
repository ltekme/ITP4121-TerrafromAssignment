variable "name" {
  description = "The EKS Cluster Name"
  type        = string
}

variable "vpc-id" {
  description = "The VPC this cluster use"
  type        = string
}

variable "subnet-ids" {
  description = "The VPC subnet this cluster use"
  type        = list(string)
}

variable "node-subnet-ids" {
  description = "The VPC subnets this cluster use for workers"
  type        = list(string)
}

variable "role-arn" {
  description = "The role this cluster use"
  type        = string
  default     = ""
}

variable "node-role-arn" {
  description = "The role this cluster use for workers"
  type        = string
  default     = ""
}

variable "cluster-access-role-arn" {
  description = "The role used to access this cluster"
  type        = string
}
