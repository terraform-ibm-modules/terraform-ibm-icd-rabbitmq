##############################################################################
# Outputs
##############################################################################

output "id" {
  description = "RabbitMQ instance id"
  value       = module.icd_rabbitmq.id
}

output "version" {
  description = "RabbitMQ instance version"
  value       = module.icd_rabbitmq.version
}

output "guid" {
  description = "RabbitMQ instance guid"
  value       = module.icd_rabbitmq.guid
}

output "crn" {
  description = "RabbitMQ instance crn"
  value       = module.icd_rabbitmq.crn
}

output "service_credentials_json" {
  description = "Service credentials json map"
  value       = module.icd_rabbitmq.service_credentials_json
  sensitive   = true
}

output "service_credentials_object" {
  description = "Service credentials object"
  value       = module.icd_rabbitmq.service_credentials_object
  sensitive   = true
}

output "hostname" {
  description = "Database connection hostname"
  value       = module.icd_rabbitmq.hostname
}

output "port" {
  description = "Database connection port"
  value       = module.icd_rabbitmq.port
}

output "secrets_manager_secrets" {
  description = "Service credential secrets"
  value       = module.icd_rabbitmq.secrets_manager_secrets
}

output "admin_pass" {
  description = "RabbitMQ administrator password"
  value       = module.icd_rabbitmq.admin_pass
  sensitive   = true
}

output "next_steps_text" {
  value       = module.icd_rabbitmq.next_steps_text
  description = "Next steps text"
}

output "next_step_primary_label" {
  value       = module.icd_rabbitmq.next_step_primary_label
  description = "Primary label"
}

output "next_step_primary_url" {
  value       = module.icd_rabbitmq.next_step_primary_url
  description = "Primary URL"
}

output "next_step_secondary_label" {
  value       = module.icd_rabbitmq.next_step_secondary_label
  description = "Secondary label"
}

output "next_step_secondary_url" {
  value       = module.icd_rabbitmq.next_step_secondary_url
  description = "Secondary URL"
}
