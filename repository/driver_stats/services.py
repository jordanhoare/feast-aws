# repository/driver_stats/services.py

"""
Feature Services allows features from within a feature view to be used
as needed by an ML model. Users can expect to create one feature service
per model, allowing for tracking of the features used by models.
"""

from feast import FeatureService

from driver_stats.views import driver_hourly_stats_view

feature_service = FeatureService(
    name="model_v1",
    features=[driver_hourly_stats_view[["conv_rate"]]],
)

feature_service_2 = FeatureService(
    name="model_v2",
    features=[driver_hourly_stats_view],
)
