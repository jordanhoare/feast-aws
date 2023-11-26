
// reference: https://docs.snowflake.com/en/user-guide/security-access-control-privileges.html#virtual-warehouse-privileges

resource "snowflake_grant_privileges_to_role" "modify" {
  for_each = { for role in var.warehouse_roles : role => ["MODIFY"] }

  role_name  = each.key
  privileges = each.value

  on_account_object {
    object_type = "WAREHOUSE"
    object_name = snowflake_warehouse.warehouse.name
  }
}

resource "snowflake_grant_privileges_to_role" "monitor" {
  for_each = { for role in var.warehouse_roles : role => ["MONITOR"] }

  role_name  = each.key
  privileges = each.value

  on_account_object {
    object_type = "WAREHOUSE"
    object_name = snowflake_warehouse.warehouse.name
  }
}

resource "snowflake_grant_privileges_to_role" "operate" {
  for_each = { for role in var.warehouse_roles : role => ["OPERATE"] }

  role_name  = each.key
  privileges = each.value

  on_account_object {
    object_type = "WAREHOUSE"
    object_name = snowflake_warehouse.warehouse.name
  }
}

resource "snowflake_grant_privileges_to_role" "usage" {
  for_each = { for role in var.warehouse_roles : role => ["USAGE"] }

  role_name  = each.key
  privileges = each.value

  on_account_object {
    object_type = "WAREHOUSE"
    object_name = snowflake_warehouse.warehouse.name
  }
}
