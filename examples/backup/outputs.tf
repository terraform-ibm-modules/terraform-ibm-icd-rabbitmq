##############################################################################
# Outputs
##############################################################################

output "id" {
  description = "RabbitMQ db instance id"
  value       = var.rmq_db_backup_crn == null ? module.rmq_db[0].id : null
}

output "restored_rmq_db_id" {
  description = "Restored RabbitMQ db instance id"
  value       = module.restored_rmq_db.id
}

output "restored_rmq_db_version" {
  description = "Restored RabbitMQ instance version"
  value       = module.restored_rmq_db.version
}
