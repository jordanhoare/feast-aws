# repository/common/sources.py

"""
Feast supports pulling data from data warehouses like BigQuery, Snowflake,
Redshift and data lakes (e.g. via Redshift Spectrum, Trino, Spark)
"""

import yaml
from feast import SnowflakeSource

# Defines a data source from which feature values can be retrieved. Sources are queried when building training
# datasets or materializing features into an online store.
project_name = yaml.safe_load(open("feature_store.yaml"))["project"]

driver_stats_source = SnowflakeSource(
    # The Snowflake table where features can be found
    database=yaml.safe_load(open("feature_store.yaml"))["offline_store"]["database"],
    table="driver_stats_feast_driver_hourly_stats",
    # The event timestamp is used for point-in-time joins and for ensuring only
    # features within the TTL are returned
    timestamp_field="event_timestamp",
    # The (optional) created timestamp is used to ensure there are no duplicate
    # feature rows in the offline store or when building training datasets
    created_timestamp_column="created",
)
