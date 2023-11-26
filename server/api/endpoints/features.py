import traceback
from datetime import datetime
from json import loads
from pathlib import Path
from typing import Any, Dict, List

import pandas as pd
from fastapi import APIRouter, HTTPException
from feast import FeatureStore
from feast.protos.feast.types.Value_pb2 import Value
from google.protobuf.json_format import MessageToDict
from pydantic import BaseModel

from server.core.logger import logger

router = APIRouter()

current_file_path = Path(__file__).resolve()
repository_path = current_file_path.parents[3] / "repository"

store = FeatureStore(repo_path=repository_path)


# Hacking this together at the moment.
def to_proto_value(value: Any) -> Value:
    if isinstance(value, int):
        return Value(int64_val=value)
    elif isinstance(value, float):
        return Value(double_val=value)
    elif isinstance(value, str):
        return Value(string_val=value)
    else:
        raise TypeError(f"Unsupported data type: {type(value)}")


class GetOnlineFeaturesRequest(BaseModel):
    features: List[str]  # Assuming features are provided as a list of strings
    entity_values: Dict[str, List[Any]]  # Mapping of entity names to their values
    full_feature_names: bool = False


@router.get("/")
def get_features():
    """Testing fetch"""
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
    feature_data = store.get_historical_features(
        entity_df=entity_df,
        features=[
            "driver_hourly_stats:conv_rate",
            "driver_hourly_stats:acc_rate",
        ],
    ).to_df()

    result = feature_data.to_json(orient="split")
    parsed = loads(result)

    return parsed


@router.post("/get-online-features")
def get_online_features(request: GetOnlineFeaturesRequest):
    try:
        # Convert entity values to Protobuf Value objects
        entity_proto_values = {
            key: [to_proto_value(val) for val in values]
            for key, values in request.entity_values.items()
        }

        response_proto = store._get_online_features(
            features=request.features,
            entity_values=entity_proto_values,
            full_feature_names=request.full_feature_names,
            native_entity_values=False,  # Set as required
        ).proto

        # Convert the Protobuf object to JSON and return it
        return MessageToDict(  # type: ignore
            response_proto, preserving_proto_field_name=True, float_precision=18
        )

    except Exception as e:
        logger.exception(traceback.format_exc())
        raise HTTPException(status_code=500, detail=str(e))
