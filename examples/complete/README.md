# Complete example with BYOK encryption, CBR rules, autoscaling, and service credentials creation

An end-to-end example that uses the IBM Cloud Terraform provider to create the following infrastructure:

- A resource group, if one is not passed in.
- A Key Protect instance with a root key.
- An instance of Messages for RabbitMQ with BYOK encryption and autoscaling enabled.
- Service credentials for the messaginginstance.
- A sample virtual private cloud (VPC).
- CA context-based restriction (CBR) rule to only allow RabbitMQ to be accessible from within the VPC.
