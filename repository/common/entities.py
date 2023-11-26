# repository/common/entities.py

from feast import Entity, ValueType

# Define an entity for the driver. You can think of an entity as a primary key used to
# fetch features.
driver = Entity(
    name="driver",
    join_keys=["driver_id"],
    value_type=ValueType.INT64,
    description="driver id",
)
