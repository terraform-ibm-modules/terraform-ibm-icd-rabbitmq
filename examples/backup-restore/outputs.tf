##############################################################################
# Outputs
##############################################################################

output "restored_rabbitmq_db_id" {
  description = "Restored RabbitMQ db instance id"
  value       = module.restored_rabbitmq_db.id
}

output "restored_rabbitmq_db_version" {
  description = "Restored RabbitMQ instance version"
  value       = module.restored_rabbitmq_db.version
}
