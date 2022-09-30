# terraform-snowflake-rbac
Quickly deploy Snowflake RBAC resources using a simple configuration model.

This module assumes the resources specified have been created in Snowflake by other means (e.g. through the Snowflake UI, using DDL commands or another Terraform project). In other words, no resources are created using this module, rather they are associated using their respective `snowflake_*_grant` Terraform resource blocks.

## TODO

- [x] Add `CREATE SCHEMA` permission to database roles
- [x] Add all relevant read/write permissions to database grants
- [x] Add all relevant read/write permissions to schema grants
- [x] Add ingest warehouse
- [x] Allow different permissions per environment
- [ ] Add a CI pipeline
- [ ] Convert this to a proper module and update the README's usage section

## Usage

### Connecting to Snowflake

Add the following configuration to your `terraform.tfvars` file using your personal credentials,

```hcl
snowflake_account                = "ab12345.ca-central-1.aws"
snowflake_username               = "Craig"
snowflake_private_key_path       = "~/.local/share/snowflake/rsa_key.p8"
snowflake_private_key_passphrase = "supersecretpassphrase"
snowflake_role                   = "ACCOUNTADMIN"
```

The Snowflake Terraform provider uses private key authentication so this must be setup before you are able to deploy resources to the Snowflake account. More information on setting up a private key pair for Snowflake can be found here: https://docs.snowflake.com/en/user-guide/key-pair-auth.html

### Configuring Resources

The YAML specification file is used to define the databases, roles, users and warehouses in a Snowflake account together with their relative permissions.

Users and Roles are associated with each other by specifying a list of `roles` in their respective specification (see below). This is equivalent to adding roles to the "Granted Roles" section in the Snowflake UI.

Database permissions are abbreviated as `read` or `write` permissions, with this module generating the proper grants. The following table shows the association between this module's permissions and Snowflake grants.

|  Objects   | Permissions | Snowflake Grants                             |
|------------|-------------|----------------------------------------------|
| Databases  | read        | USAGE                                        |
|            | write       | MONITOR, CREATE SCHEMA                       |
| Schemas    | read        | USAGE                                        |
|            | write       | MONITOR, CREATE TABLE, CREATE VIEW, CREATE STAGE, CREATE FILE FORMAT, CREATE SEQUENCE, CREATE FUNCTION, CREATE PIPE                                 |
| Tables     | read        | SELECT                                       |
|            | write       | INSERT, UPDATE, DELETE, TRUNCATE, REFERENCES |
| Warehouses |             | USAGE, OPERATE, MONITOR                      |

For `schemas` and `tables`, if no permission is specified, then the permissions specified for the database are assumed. The `warehouse` objects have a single permission type so they are specified without a `read` or `write` qualifier (see below).

#### spec.yml

A specification file has the following structure:

```yaml
# Roles
roles:
  role_name:
    roles:
      - role_name
  role_name:
    roles:
      - role_name
      - ...
    warehouses:
      - warehouse_name
      - ...
    databases:
      read:
        - database_name
        - ...
      write:
        - database_name
        - ...
    schemas:
      read:
        - schema_name
        - ...
      write:
        - schema_name
        - ...
    tables:
      read:
        - table_name
        - ...
      write:
        - table_name
        - ...
  ... ... ...

# Users
users:
  user_name:
    roles:
      - role_name
      - ...
  ... ... ...
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_snowflake"></a> [snowflake](#requirement\_snowflake) | 0.43.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_snowflake.securityadmin"></a> [snowflake.securityadmin](#provider\_snowflake.securityadmin) | 0.43.0 |
| <a name="provider_snowflake.sysadmin"></a> [snowflake.sysadmin](#provider\_snowflake.sysadmin) | 0.43.0 |
| <a name="provider_snowflake.useradmin"></a> [snowflake.useradmin](#provider\_snowflake.useradmin) | 0.43.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [snowflake_database.databases](https://registry.terraform.io/providers/Snowflake-Labs/snowflake/0.43.0/docs/resources/database) | resource |
| [snowflake_database_grant.database_grants](https://registry.terraform.io/providers/Snowflake-Labs/snowflake/0.43.0/docs/resources/database_grant) | resource |
| [snowflake_role.roles](https://registry.terraform.io/providers/Snowflake-Labs/snowflake/0.43.0/docs/resources/role) | resource |
| [snowflake_role_grants.role_grants](https://registry.terraform.io/providers/Snowflake-Labs/snowflake/0.43.0/docs/resources/role_grants) | resource |
| [snowflake_role_grants.user_grants](https://registry.terraform.io/providers/Snowflake-Labs/snowflake/0.43.0/docs/resources/role_grants) | resource |
| [snowflake_schema_grant.schema_grants](https://registry.terraform.io/providers/Snowflake-Labs/snowflake/0.43.0/docs/resources/schema_grant) | resource |
| [snowflake_table_grant.table_grants_r](https://registry.terraform.io/providers/Snowflake-Labs/snowflake/0.43.0/docs/resources/table_grant) | resource |
| [snowflake_table_grant.table_grants_rw](https://registry.terraform.io/providers/Snowflake-Labs/snowflake/0.43.0/docs/resources/table_grant) | resource |
| [snowflake_user.users](https://registry.terraform.io/providers/Snowflake-Labs/snowflake/0.43.0/docs/resources/user) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_data_stages"></a> [data\_stages](#input\_data\_stages) | The list of data stages to create in the Snowflake account. | `list(string)` | n/a | yes |
| <a name="input_environments"></a> [environments](#input\_environments) | The list of environments to create in the Snowflake account. | `list(string)` | n/a | yes |
| <a name="input_role_grants"></a> [role\_grants](#input\_role\_grants) | A map of roles and which role they are granted to. | `map(list(string))` | n/a | yes |
| <a name="input_snowflake_account"></a> [snowflake\_account](#input\_snowflake\_account) | The Snowflake account that we will be deploying into. | `string` | n/a | yes |
| <a name="input_snowflake_private_key_passphrase"></a> [snowflake\_private\_key\_passphrase](#input\_snowflake\_private\_key\_passphrase) | The passphrase for the private key used to authenticate the Snowflake user. | `string` | n/a | yes |
| <a name="input_snowflake_private_key_path"></a> [snowflake\_private\_key\_path](#input\_snowflake\_private\_key\_path) | The path to the private key used to authenticate the Snowflake user. | `string` | n/a | yes |
| <a name="input_snowflake_role"></a> [snowflake\_role](#input\_snowflake\_role) | The Snowflake role used to deploy into the Snowflake account. | `string` | n/a | yes |
| <a name="input_snowflake_username"></a> [snowflake\_username](#input\_snowflake\_username) | The name of the Snowflake user used to deploy into the Snowflake account. | `string` | n/a | yes |
| <a name="input_user_grants"></a> [user\_grants](#input\_user\_grants) | A map of users and which role they are granted to. | `map(list(string))` | n/a | yes |

## Outputs

No outputs.
