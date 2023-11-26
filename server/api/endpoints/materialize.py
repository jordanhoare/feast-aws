import traceback
from datetime import datetime, timedelta
from pathlib import Path
from typing import List, Optional

from dateutil import parser
from fastapi import APIRouter, HTTPException, Request
from feast import FeatureStore, utils
from pydantic import BaseModel, Field

from server.core.logger import logger

router = APIRouter()

current_file_path = Path(__file__).resolve()
repository_path = current_file_path.parents[3] / "repository"

store = FeatureStore(repo_path=repository_path)


class MaterializeRequest(BaseModel):
    start_ts: str = Field(
        default_factory=lambda: (datetime.utcnow() - timedelta(hours=12)).isoformat()
    )
    end_ts: str = Field(
        default_factory=lambda: (datetime.utcnow() - timedelta(minutes=10)).isoformat()
    )
    feature_views: Optional[List[str]] = None


async def get_body(request: Request):
    return await request.body()


@router.post("")
def materialize(request: MaterializeRequest):
    logger.info("Materializing features from offline to online store")

    try:
        store.materialize(
            utils.make_tzaware(parser.parse(request.start_ts)),
            utils.make_tzaware(parser.parse(request.end_ts)),
            request.feature_views,
        )
    except Exception as e:
        # Print the original exception on the server side
        logger.exception(traceback.format_exc())
        # Raise HTTPException to return the error message to the client
        raise HTTPException(status_code=500, detail=str(e))
