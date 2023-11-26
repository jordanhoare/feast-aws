# repository/driver_stats/services.py

"""
Feature Services allows features from within a feature view to be used
as needed by an ML model. Users can expect to create one feature service
per model, allowing for tracking of the features used by models.
"""

from feast import FeatureService

from driver_stats.views import driver_stats_fv
from driver_stats.transformations import transformed_conv_rate

# This groups features into a model version
driver_activity_v1 = FeatureService(
    name="driver_activity_v1",
    features=[
        driver_stats_fv[["conv_rate"]],  # Sub-selects a feature from a feature view
        transformed_conv_rate,  # Selects all features from the feature view
    ],
)
driver_activity_v2 = FeatureService(
    name="driver_activity_v2", features=[driver_stats_fv, transformed_conv_rate]
)
