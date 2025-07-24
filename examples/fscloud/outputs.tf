##############################################################################
# Outputs
##############################################################################
output "id" {
  description = "RabbitMQ instance id"
  value       = module.rabbitmq_database.id
}

output "guid" {
  description = "RabbitMQ instance guid"
  value       = module.rabbitmq_database.guid
}

output "version" {
  description = "RabbitMQ instance version"
  value       = module.rabbitmq_database.version
}

output "hostname" {
  description = "Database hostname. Only contains value when var.service_credential_names or var.users are set."
  value       = module.rabbitmq_database.hostname
}

output "port" {
  description = "Database port. Only contains value when var.service_credential_names or var.users are set."
  value       = module.rabbitmq_database.port
}
