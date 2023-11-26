# repository/driver_stats/views.py

from datetime import timedelta

from feast import FeatureView, Field
from feast.types import Float32, Int64

from common.entities import driver
from common.sources import driver_stats_source

conv_rate = Field(name="conv_rate", dtype=Float32)
acc_rate = Field(name="acc_rate", dtype=Float32)
avg_daily_trips = Field(name="avg_daily_trips", dtype=Int64),

# Feature views are a grouping based on how features are stored in either the
# online or offline store.
driver_stats_fv = FeatureView(
    # The unique name of this feature view. Two feature views in a single
    # project cannot have the same name
    name="driver_hourly_stats",
    description="Hourly features",
    # The list of entities specifies the keys required for joining or looking
    # up features from this feature view. The reference provided in this field
    # correspond to the name of a defined entity (or entities)
    entities=[driver],
    # The timedelta is the maximum age that each feature value may have
    # relative to its lookup time. For historical features (used in training),
    # TTL is relative to each timestamp provided in the entity dataframe.
    # TTL also allows for eviction of keys from online stores and limits the
    # amount of historical scanning required for historical feature values
    # during retrieval
    ttl=timedelta(weeks=52 * 10),  # Set to be very long for example purposes only
    # The list of features defined below act as a schema to both define features
    # for both materialization of features into a store, and are used as references
    # during retrieval for building a training dataset or serving features
    schema=[conv_rate, acc_rate, avg_daily_trips],
    source=driver_stats_source,
)
