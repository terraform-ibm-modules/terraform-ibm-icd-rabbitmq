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

output "hostname" {
  description = "Database hostname. Only contains value when var.service_credential_names or var.users are set."
  value       = module.rabbitmq_database.hostname
}

output "port" {
  description = "Database port. Only contains value when var.service_credential_names or var.users are set."
  value       = module.rabbitmq_database.port
}
