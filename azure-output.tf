output "azure-resource_group_name" {
  value = azurerm_resource_group.rg1.name
}

output "azure-client_id" {
  description = "The application id of AzureAD application created."
  value       = module.ServicePrincipal.client_id
}

output "azure-client_secret" {
  description = "Password for service principal."
  value       = module.ServicePrincipal.client_secret
  sensitive = true
}