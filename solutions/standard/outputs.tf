##############################################################################
# Outputs
##############################################################################

output "id" {
  description = "RabbitMQ instance id"
  value       = local.rabbitmq_id
}

output "version" {
  description = "RabbitMQ instance version"
  value       = local.rabbitmq_version
}

output "guid" {
  description = "RabbitMQ instance guid"
  value       = local.rabbitmq_guid
}

output "crn" {
  description = "RabbitMQ instance crn"
  value       = local.rabbitmq_crn
}

output "service_credentials_json" {
  description = "Service credentials json map"
  value       = var.existing_db_instance_crn != null ? null : module.rabbitmq[0].service_credentials_json
  sensitive   = true
}

output "service_credentials_object" {
  description = "Service credentials object"
  value       = var.existing_db_instance_crn != null ? null : module.rabbitmq[0].service_credentials_object
  sensitive   = true
}

output "hostname" {
  description = "Database connection hostname"
  value       = local.rabbitmq_hostname
}

output "port" {
  description = "Database connection port"
  value       = local.rabbitmq_port
}

output "secrets_manager_secrets" {
  description = "Service credential secrets"
  value       = length(local.service_credential_secrets) > 0 ? module.secrets_manager_service_credentials[0].secrets : null
}

output "admin_pass" {
  description = "RabbitMQ administrator password"
  value       = local.admin_pass
  sensitive   = true
}
