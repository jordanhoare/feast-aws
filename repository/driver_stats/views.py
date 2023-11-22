# repository/driver_stats/views.py

from datetime import timedelta

from feast import FeatureView, Field
from feast.types import Float32

from common.sources import driver_stats
from common.entities import driver

conv_rate = Field(name="conv_rate", dtype=Float32)
acc_rate = Field(name="acc_rate", dtype=Float32)

driver_hourly_stats_view = FeatureView(
    name="driver_hourly_stats",
    description="Hourly features",
    entities=[driver],
    ttl=timedelta(seconds=8640000000),
    schema=[conv_rate, acc_rate],
    source=driver_stats,
    online=True,
)

# from datetime import timedelta

# from feast import Feature, FeatureView, ValueType

# from common.sources import driver_stats
# from common.entities import driver

# conv_rate = Feature(name="conv_rate", dtype=ValueType.FLOAT)
# acc_rate = Feature(name="acc_rate", dtype=ValueType.FLOAT)

# driver_hourly_stats_view = FeatureView(
#     name="driver_hourly_stats",
#     description="Hourly features",
#     entities=[driver],
#     ttl=timedelta(seconds=8640000000),
#     schema=[conv_rate, acc_rate],
#     source=driver_stats,
#     online=True,
# )
