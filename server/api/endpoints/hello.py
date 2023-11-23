from fastapi import APIRouter

from server.core.logger import logger

router = APIRouter()


@router.get('/')
def read_root():
    logger.info('This is an example of logging')
    return {'hello': 'world'}
