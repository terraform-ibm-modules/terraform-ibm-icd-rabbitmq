##############################################################################
# Outputs
##############################################################################

output "id" {
  description = "RabbitMQ instance id"
  value       = module.rabbitmq.id
}

output "version" {
  description = "RabbitMQ instance version"
  value       = module.rabbitmq.version
}

output "guid" {
  description = "RabbitMQ instance guid"
  value       = module.rabbitmq.guid
}

output "crn" {
  description = "RabbitMQ instance crn"
  value       = module.rabbitmq.crn
}

output "cbr_rule_ids" {
  description = "CBR rule ids created to restrict RabbitMQ"
  value       = module.rabbitmq.cbr_rule_ids
}

output "service_credentials_json" {
  description = "Service credentials json map"
  value       = module.rabbitmq.service_credentials_json
  sensitive   = true
}

output "service_credentials_object" {
  description = "Service credentials object"
  value       = module.rabbitmq.service_credentials_object
  sensitive   = true
}

output "adminuser" {
  description = "Database admin user name"
  value       = module.rabbitmq.adminuser
}

output "hostname" {
  description = "Database connection hostname"
  value       = module.rabbitmq.hostname
}

output "port" {
  description = "Database connection port"
  value       = module.rabbitmq.port
}

output "certificate_base64" {
  description = "Database connection certificate"
  value       = module.rabbitmq.certificate_base64
  sensitive   = true
}

output "secrets_manager_secrets" {
  description = "Service credential secrets"
  value       = length(local.service_credential_secrets) > 0 ? module.secrets_manager_service_credentials[0].secrets : null
}
