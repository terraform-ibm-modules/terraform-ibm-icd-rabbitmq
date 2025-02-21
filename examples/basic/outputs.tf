##############################################################################
# Outputs
##############################################################################
output "id" {
  description = "RabbitMQ instance id"
  value       = module.database.id
}

output "rabbitmq_crn" {
  description = "RabbitMQ CRN"
  value       = module.database.crn
}

output "version" {
  description = "RabbitMQ instance version"
  value       = module.database.version
}

output "adminuser" {
  description = "Database admin user name"
  value       = module.database.adminuser
}

output "hostname" {
  description = "Database hostname"
  value       = module.database.hostname
}

output "port" {
  description = "Database port"
  value       = module.database.port
}

output "certificate_base64" {
  description = "Database connection certificate"
  value       = module.database.certificate_base64
  sensitive   = true
}
