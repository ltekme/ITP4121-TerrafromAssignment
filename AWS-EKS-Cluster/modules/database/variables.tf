variable "database-name" {
  description = "The name of the database"
  type        = string
}

variable "availability_zone" {
  description = "The az this db in"
  type        = string
}

variable "vpc-id" {
  description = "The VPC this db uses"
  type        = string
}

variable "subnets" {
  description = "The subnets this db in"
  type        = list(string)
}

variable "sg-ingress-blocks" {
  description = "The vpc ingress cidr blocks"
  type        = list(string)
}

variable "master-username" {
  description = "The default username of the master user"
  type        = string
}

variable "master-password" {
  description = "The default password for the master user"
  type        = string
}
