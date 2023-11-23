from fastapi import APIRouter
from fastapi.responses import FileResponse

from server.core.logger import logger
from server.core.config import get_settings

router = APIRouter()
settings = get_settings()


@router.get("")
def get_registry():
    logger.info('Serving the registry.pb file.')
    file_response = FileResponse(
        path=settings.LOCAL_REGISTRY_PATH,
        media_type="application/octet-stream",
        )
    return file_response
