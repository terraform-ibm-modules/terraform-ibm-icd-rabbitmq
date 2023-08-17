##############################################################################
# Outputs
##############################################################################

output "id" {
  description = "RabbitMQ instance id"
  value       = ibm_database.rabbitmq_database.id
}

output "guid" {
  description = "RabbitMQ instance guid"
  value       = ibm_database.rabbitmq_database.guid
}

output "version" {
  description = "RabbitMQ instance version"
  value       = ibm_database.rabbitmq_database.version
}

output "crn" {
  description = "RabbitMQ instance crn"
  value       = ibm_database.rabbitmq_database.resource_crn
}

output "cbr_rule_ids" {
  description = "CBR rule ids created to restrict RabbitMQ"
  value       = module.cbr_rule[*].rule_id
}

output "service_credentials_json" {
  description = "Service credentials json map"
  value       = local.service_credentials_json
  sensitive   = true
}

output "service_credentials_object" {
  description = "Service credentials object"
  value       = local.service_credentials_object
  sensitive   = true
}

output "hostname" {
  description = "Database hostname. Only contains value when var.service_credential_names or var.users are set."
  value       = length(var.service_credential_names) > 0 ? nonsensitive(ibm_resource_key.service_credentials[keys(var.service_credential_names)[0]].credentials["connection.https.hosts.0.hostname"]) : length(var.users) > 0 ? nonsensitive(flatten(data.ibm_database_connection.database_connection[0].https[0].hosts[0].hostname)) : null
}

output "port" {
  description = "Database port. Only contains value when var.service_credential_names or var.users are set."
  value       = length(var.service_credential_names) > 0 ? nonsensitive(ibm_resource_key.service_credentials[keys(var.service_credential_names)[0]].credentials["connection.https.hosts.0.port"]) : length(var.users) > 0 ? nonsensitive(flatten(data.ibm_database_connection.database_connection[0].https[0].hosts[0].port)) : null
}
