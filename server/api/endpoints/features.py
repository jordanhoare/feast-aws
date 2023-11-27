import traceback
from datetime import datetime
from json import loads

import pandas as pd
from fastapi import APIRouter, HTTPException, Request
from google.protobuf.json_format import MessageToDict

from server.logger import logger
from server.models import GetOnlineFeaturesRequest
from server.utils import to_proto_value

router = APIRouter()


@router.post("/get-online-features")
def get_online_features(request: Request, body: GetOnlineFeaturesRequest):
    feature_store = request.app.state.feature_store

    try:
        # Convert entity values to Protobuf Value objects
        entity_proto_values = {
            key: [to_proto_value(val) for val in values]
            for key, values in body.entity_values.items()
        }

        response_proto = feature_store._get_online_features(
            features=body.features,
            entity_values=entity_proto_values,
            full_feature_names=body.full_feature_names,
            native_entity_values=False,  # Set as required
        ).proto

        # Convert the Protobuf object to JSON and return it
        return MessageToDict(  # type: ignore
            response_proto, preserving_proto_field_name=True, float_precision=18
        )

    except Exception as e:
        logger.exception(traceback.format_exc())
        raise HTTPException(status_code=500, detail=str(e))


@router.get("/")
def get_features(request: Request):
    """Testing fetch"""

    feature_store = request.app.state.feature_store

    logger.info("Fetching features for entity")

    entity_df = pd.DataFrame.from_dict(
        {
            "driver_id": [1001, 1002, 1003, 1004, 1001],
            "event_timestamp": [
                datetime(2023, 11, 26, 10, 59, 42),
                datetime(2021, 11, 26, 8, 12, 10),
                datetime(2021, 11, 26, 16, 40, 26),
                datetime(2021, 11, 26, 15, 1, 12),
                datetime.now(),
            ],
        }
    )
    feature_data = feature_store.get_historical_features(
        entity_df=entity_df,
        features=[
            "driver_hourly_stats:conv_rate",
            "driver_hourly_stats:acc_rate",
        ],
    ).to_df()

    result = feature_data.to_json(orient="split")
    parsed = loads(result)

    return parsed
