# server\api\endpoints\hello.py

import pandas as pd
from json import loads, dumps
from fastapi import APIRouter
from feast import FeatureStore
from datetime import datetime, timedelta
from server.core.logger import logger

router = APIRouter()

store = FeatureStore(repo_path="../../../repository")


@router.get('/')
def get_features():
    logger.info('Fetching features for entity')
    features = ["driver_hourly_stats:conv_rate", "driver_hourly_stats:acc_rate"]

    entity_df = pd.DataFrame(
        {
            "event_timestamp": [
                pd.Timestamp(dt, unit="ms", tz="UTC").round("ms")
                for dt in pd.date_range(
                    start=datetime.now() - timedelta(days=3),
                    end=datetime.now(),
                    periods=3,
                )
            ],
            "driver_id": [1001, 1002, 1003],
        }
    )

    feature_data = store.get_historical_features(
        features=features, entity_df=entity_df
    ).to_df()

    result = feature_data.to_json(orient="split")
    parsed = loads(result)

    return parsed
