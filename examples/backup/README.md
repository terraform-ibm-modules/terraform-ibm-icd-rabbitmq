# Restore from backup example

This example provides an end-to-end executable flow of how a RabbitMQ DB can be created from a backup instance. This example uses the IBM Cloud terraform provider to:

- Create a new resource group if one is not passed in.
- Create a new ICD RabbitMQ database instance if no existing backup crn is provided.
- Create a restored ICD RabbitMQ database instance pointing to the backup of the first instance.
