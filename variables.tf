# Provider
variable "snowflake_account" {
  type        = string
  description = "The Snowflake account that we will be deploying into."
}

variable "snowflake_username" {
  type        = string
  description = "The name of the Snowflake user used to deploy into the Snowflake account."
}

variable "snowflake_private_key_path" {
  type        = string
  description = "The path to the private key used to authenticate the Snowflake user."
  sensitive   = true
}

variable "snowflake_private_key_passphrase" {
  type        = string
  description = "The passphrase for the private key used to authenticate the Snowflake user."
  sensitive   = true
}

variable "snowflake_role" {
  type        = string
  description = "The Snowflake role used to deploy into the Snowflake account."
}

# Configuration
variable "environments" {
  type        = list(string)
  description = "The list of environments to create in the Snowflake account."
}

variable "data_stages" {
  type        = list(string)
  description = "The list of data stages to create in the Snowflake account."
}

variable "user_grants" {
  type        = map(list(string))
  description = "A map of users and which role they are granted to."
}

variable "role_grants" {
  type        = map(list(string))
  description = "A map of roles and which role they are granted to."
}

#variable "user_role_grants" {
#  type        = map(string)
#  description = "A map of user roles and which role they are granted to."
#}
#
#variable "data_stage_role_grants" {
#  type        = map(string)
#  description = "A map of data stage roles and which role they are granted to."
#}
