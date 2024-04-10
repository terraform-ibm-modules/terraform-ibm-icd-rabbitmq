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

output "crn" {
  description = "RabbitMQ instance crn"
  value       = module.rabbitmq_database.crn
}

output "cbr_rule_ids" {
  description = "CBR rule ids created to restrict RabbitMQ"
  value       = module.rabbitmq_database.cbr_rule_ids
}

output "service_credentials_json" {
  description = "Service credentials json map"
  value       = module.rabbitmq_database.service_credentials_json
  sensitive   = true
}

output "service_credentials_object" {
  description = "Service credentials object"
  value       = module.rabbitmq_database.service_credentials_object
  sensitive   = true
}

output "adminuser" {
  description = "Database admin user name"
  value       = module.rabbitmq_database.adminuser
}

output "hostname" {
  description = "Database connection hostname"
  value       = module.rabbitmq_database.hostname
}

output "port" {
  description = "Database connection port"
  value       = module.rabbitmq_database.port
}

output "certificate_base64" {
  description = "Database connection certificate"
  value       = module.rabbitmq_database.certificate_base64
  sensitive   = true
}
