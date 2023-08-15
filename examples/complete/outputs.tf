##############################################################################
# Outputs
##############################################################################

output "id" {
  description = "RabbitMQ instance id"
  value       = module.icd_rabbitmq.id
}

output "guid" {
  description = "Postgresql instance guid"
  value       = module.icd_rabbitmq.guid
}

output "version" {
  description = "RabbitMQ instance version"
  value       = module.icd_rabbitmq.version
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
  description = "Database hostname. Only contains value when var.service_credential_names or var.users are set."
  value       = module.icd_rabbitmq.hostname
}

output "port" {
  description = "Database port. Only contains value when var.service_credential_names or var.users are set."
  value       = module.icd_rabbitmq.port
}
