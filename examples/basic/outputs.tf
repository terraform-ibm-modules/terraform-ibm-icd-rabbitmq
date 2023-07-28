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
