variable "project-name" {
  description = "The name of the project(can only contain letters, numbers, and hyphens)"
  type        = string
}

variable "aws-region" {
  description = "AWS Region code to deploy the resources in"
  type        = string
}

variable "deploy-aws" {
  description = "Weather to deploy infrasecture in aws"
  type        = bool
}
