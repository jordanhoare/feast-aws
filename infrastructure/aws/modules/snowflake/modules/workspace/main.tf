terraform {
  required_providers {
    snowflake = {
      source  = "Snowflake-Labs/snowflake"
      configuration_aliases = [snowflake.ACCOUNTADMIN, snowflake.SECURITYADMIN]
    }
    aws = {}
  }
  required_version = ">= 1.0"
  experiments      = [module_variable_optional_attrs]
}
