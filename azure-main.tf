module "aws-eks-cluster" {
  source                      = "./AZURE-AKS-Cluster"
  location                    = var.azure-location
  rgname                      = var.azure-rgname
  service_principal_name      = var.azure-service_principal_name
  keyvault_name               = var.azure-keyvault_name
  SUB_ID                      = var.azure-SUB_ID
  clustername                 = var.azure-clustername
}