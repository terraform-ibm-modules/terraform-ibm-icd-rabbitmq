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
