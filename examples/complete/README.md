# Complete example with BYOK encryption, CBR rules, autoscaling, and service credentials creation

An end-to-end example that does the following:

- Create a new resource group if one is not passed in.
- Create Key Protect instance with root key.
- Create a new Messages for RabbitMQ instance with BYOK encryption and autoscaling enabled.
- Create service credentials for the instance.
- Create a Virtual Private Cloud (VPC).
- Create Context Based Restriction (CBR) to only allow RabbitMQ to be accessible from the VPC.
