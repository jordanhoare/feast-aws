import traceback

from dateutil import parser
from fastapi import APIRouter, HTTPException, Request

from server.logger import logger
from server.models import MaterializeRequest
from server.utils import make_tzaware

router = APIRouter()


@router.post("")
def materialize(request: Request, params: MaterializeRequest):
    # Access the feature store from the application state
    feature_store = request.app.state.feature_store

    try:
        logger.info("Materializing features from offline to online store")
        feature_store.materialize(
            make_tzaware(parser.parse(params.start_ts)),
            make_tzaware(parser.parse(params.end_ts)),
            params.feature_views,
        )

    except Exception as e:
        logger.exception(traceback.format_exc())
        raise HTTPException(status_code=500, detail=str(e))
