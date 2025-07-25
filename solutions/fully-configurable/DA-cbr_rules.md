# Configuring complex inputs for ICD Elastic Search in IBM Cloud projects

Several optional input variables in the IBM Cloud [ICD Messages for Rabbitmq Deployable Architecture](https://cloud.ibm.com/catalog#deployable_architecture) use complex object types. You specify these inputs when you configure deployable architecture.

* Context-Based Restrictions Rules (`cbr_rules`)


## Rules For Context-Based Restrictions <a name="cbr_rules"></a>

The `cbr_rules` input variable allows you to provide a rule for the target service to enforce access restrictions for the service based on the context of access requests. Contexts are criteria that include the network location of access requests, the endpoint type from where the request is sent, etc.

- Variable name: `cbr_rules`.
- Type: A list of objects. Allows only one object representing a rule for the target service
- Default value: An empty list (`[]`).

### Options for cbr_rules

  - `description` (required): The description of the rule to create.
  - `account_id` (required): The IBM Cloud Account ID
  - `rule_contexts` (required): (List) The contexts the rule applies to
      - `attributes` (optional): (List) Individual context attributes
        - `name` (required): The attribute name.
        - `value`(required): The attribute value.

  - `enforcement_mode` (required): The rule enforcement mode can have the following values:
      - `enabled` - The restrictions are enforced and reported. This is the default.
      - `disabled` - The restrictions are disabled. Nothing is enforced or reported.
      - `report` - The restrictions are evaluated and reported, but not enforced.
  - `tags` (required): The tag can have the following values:
      - `name` - The name of the tag.
      - `value` - The value of the tag.
  - `operations` (optional): The operations this rule applies to
    - `api_types`(required): (List) The API types this rule applies to.
        - `api_type_id`(required):The API type ID


### Example Rule For Context-Based Restrictions Configuration

```hcl
[
  {
    "description"     : "SCC Instance can be accessed from xyz"
    "account_id"      : "defc0df06b644a9cabc6e44f55b3880s."
    "rule_contexts"   : [{
      "attributes"  : [
        {
          "name" : "endpointType",
          "value" : "private"
        },
        {
          "name"  : "networkZoneId"
          "value" : "93a51a1debe2674193217209601dde6f" # pragma: allowlist secret
        }
      ]
    }]
    "enforcement_mode" : "enabled"
    "operations" : [{
      "api_types" : [{
        "api_type_id" : "crn:v1:bluemix:public:context-based-restrictions::::api-type:"
      }]
    }]
  }
]
```
