output "id" {
  description = "PostgreSQL server ID."
  value       = azurerm_postgresql_flexible_server.this.id
}

output "fqdn" {
  description = "PostgreSQL private FQDN."
  value       = azurerm_postgresql_flexible_server.this.fqdn
}

output "database_names" {
  description = "Database names."
  value       = [for database in azurerm_postgresql_flexible_server_database.this : database.name]
}
