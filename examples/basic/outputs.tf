##############################################################################
# Outputs
##############################################################################
output "id" {
  description = "rabbitmq instance id"
  value       = module.icd_rabbitmq.id
}

output "version" {
  description = "rabbitmq instance version"
  value       = module.icd_rabbitmq.version
}

output "adminuser" {
  description = "Database admin user name"
  value       = module.icd_rabbitmq.adminuser
}

output "hostname" {
  description = "Database hostname"
  value       = module.icd_rabbitmq.hostname
}

output "port" {
  description = "Database port"
  value       = module.icd_rabbitmq.port
}

output "certificate_base64" {
  description = "Database connection certificate"
  value       = module.icd_rabbitmq.certificate_base64
  sensitive   = true
}
