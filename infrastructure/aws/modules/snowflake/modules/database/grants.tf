// reference: https://docs.snowflake.com/en/user-guide/security-access-control-privileges.html

locals {
  # granted to reader_roles + admin_roles
  read_privileges = {
    database = ["USAGE"]
    schema   = ["USAGE"]
    table    = ["SELECT", "REFERENCES"]
    view     = ["SELECT", "REFERENCES"]
  }
  # granted to admin_roles only
  additional_admin_privileges = {
    database = ["CREATE SCHEMA"]
    schema = [
      "CREATE EXTERNAL TABLE",
      "CREATE FILE FORMAT",
      "CREATE FUNCTION",
      "CREATE MASKING POLICY",
      "CREATE MATERIALIZED VIEW",
      "CREATE PIPE",
      "CREATE PROCEDURE",
      # Requires Snowflake Enterprise Edition
      # "CREATE ROW ACCESS POLICY",
      "CREATE SEQUENCE",
      "CREATE STAGE",
      "CREATE STREAM",
      "CREATE TABLE",
      # TODO: waiting for https://github.com/chanzuckerberg/terraform-provider-snowflake/issues/734
      # "CREATE TAG",
      "CREATE TASK",
      "CREATE VIEW",
      "MODIFY",
      "MONITOR",
    ]
    table = [
      "DELETE",
      "INSERT",
      "TRUNCATE",
      "UPDATE",
    ]
    view = []
  }
}


// apply read_privileges defined above to reader_roles + admin_roles
resource "snowflake_grant_privileges_to_role" "read_privileges_database" {
  for_each = { for role in concat(var.reader_roles, var.admin_roles) : role => local.read_privileges.database }

  role_name  = each.key
  privileges = each.value

  on_account_object {
    object_type = "DATABASE"
    object_name = snowflake_database.db.name
  }
}

resource "snowflake_grant_privileges_to_role" "read_privileges_schema" {
  for_each = { for role in concat(var.reader_roles, var.admin_roles) : role => local.read_privileges.schema }

  role_name  = each.key
  privileges = each.value

  on_account_object {
    object_type = "SCHEMA"
    object_name = snowflake_database.db.name
  }
}

resource "snowflake_grant_privileges_to_role" "read_privileges_table" {
  for_each = { for role in concat(var.reader_roles, var.admin_roles) : role => local.read_privileges.table }

  role_name  = each.key
  privileges = each.value

  on_account_object {
    object_type = "TABLE"
    object_name = snowflake_database.db.name
  }
}


resource "snowflake_grant_privileges_to_role" "read_privileges_view" {
  for_each = { for role in concat(var.reader_roles, var.admin_roles) : role => local.read_privileges.view }

  role_name  = each.key
  privileges = each.value

  on_account_object {
    object_type = "VIEW"
    object_name = snowflake_database.db.name
  }
}

// apply read_privileges defined above to reader_roles + admin_roles
resource "snowflake_grant_privileges_to_role" "additional_admin_privileges_schema" {
  for_each = { for role in var.admin_roles : role => local.additional_admin_privileges.schema }

  role_name  = each.key
  privileges = each.value

  on_account_object {
    object_type = "SCHEMA"
    object_name = snowflake_database.db.name
  }
}

resource "snowflake_grant_privileges_to_role" "additional_admin_privileges_table" {
  for_each = { for role in var.admin_roles : role => local.additional_admin_privileges.table }

  role_name  = each.key
  privileges = each.value

  on_account_object {
    object_type = "TABLE"
    object_name = snowflake_database.db.name
  }
}

resource "snowflake_grant_privileges_to_role" "additional_admin_privileges_view" {
  for_each = { for role in var.admin_roles : role => local.additional_admin_privileges.view }

  role_name  = each.key
  privileges = each.value

  on_account_object {
    object_type = "VIEW"
    object_name = snowflake_database.db.name
  }
}

resource "snowflake_grant_privileges_to_role" "additional_admin_privileges_database" {
  for_each = { for role in var.admin_roles : role => local.additional_admin_privileges.database }

  role_name  = each.key
  privileges = each.value

  on_account_object {
    object_type = "DATABASE"
    object_name = snowflake_database.db.name
  }
}
