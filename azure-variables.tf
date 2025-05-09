variable "azure-location" {
  type    = string
}

variable "azure-rgname" {
  type        = string
  description = "resource group name"
}

variable "azure-service_principal_name" {
  type = string
}

variable "azure-keyvault_name" {
  type = string
}

variable "azure-SUB_ID" {
  type = string
}

##
variable "azure-clustername" {
  type = string
  default = "aks-cluster"
}