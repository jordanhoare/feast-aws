import uvicorn

from .core.application import create_api
from .core.config import get_settings

if __name__ == "__main__":
    api = create_api()
    settings = get_settings()
    uvicorn.run(
        api,
        host=settings.SERVER_HOST,
        port=settings.SERVER_PORT,
        workers=settings.SERVER_WORKERS,
    )
