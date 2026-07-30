# IBM Cloud Messages Gen 2 (VPC) for RabbitMQ

This deployable architecture provides a fully configurable solution for IBM Cloud Messages Gen 2 (VPC) for RabbitMQ. For more information about Gen 2, see [Messages for RabbitMQ Gen 2](https://cloud.ibm.com/docs/messages-for-rabbitmq-gen2?topic=messages-for-rabbitmq-gen2-provisioning&interface=ui).

:exclamation: **Important:** This solution is not intended to be called by other modules because it contains a provider configuration and is not compatible with the `for_each`, `count`, and `depends_on` arguments. For more information, see [Providers Within Modules](https://developer.hashicorp.com/terraform/language/modules/develop/providers).
