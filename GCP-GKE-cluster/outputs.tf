output "cluster" {
  value = google_container_cluster.primary
}

output "access-token" {
  value = data.google_client_config.provider.access_token
}

output "database" {
  value = google_sql_database_instance.main
}

output "database-user" {
  value = google_sql_user.default
}
