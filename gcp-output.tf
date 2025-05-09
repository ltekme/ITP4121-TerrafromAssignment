output "database-url" {
  value = module.gcp-infra.database
}

output "database-username" {
  value = module.gcp-infra.database-user.name
}

output "database-password" {
  sensitive = true
  value     = module.gcp-infra.database-user.password
}
