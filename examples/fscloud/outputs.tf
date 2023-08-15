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
