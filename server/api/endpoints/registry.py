from fastapi import APIRouter
from fastapi.responses import FileResponse

from server.config import settings
from server.logger import logger

router = APIRouter()


@router.get("")
def get_registry():
    logger.info("Serving the registry.pb file.")
    file_response = FileResponse(
        path=settings.LOCAL_REGISTRY_PATH,
        media_type="application/octet-stream",
    )
    return file_response
