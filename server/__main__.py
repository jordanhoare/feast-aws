import uvicorn

from .application import create_api
from .config import settings

if __name__ == "__main__":
    api = create_api()
    uvicorn.run(
        api,
        host=settings.SERVER_HOST,
        port=settings.SERVER_PORT,
        workers=settings.SERVER_WORKERS,
    )
