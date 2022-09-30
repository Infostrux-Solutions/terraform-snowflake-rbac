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
