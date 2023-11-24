from functools import lru_cache

from dotenv import load_dotenv
from pydantic import BaseSettings

load_dotenv()


class LocalSettings(BaseSettings):
    SERVICE_NAME: str = "service_name"
    SERVER_HOST: str = "0.0.0.0"
    SERVER_PORT: int = 8000
    SERVER_WORKERS: int = 1
    API_V1_STR: str = "/api/v1"
    LOCAL_REGISTRY_PATH: str = "server/registry.pb"


@lru_cache
def get_settings() -> LocalSettings:
    return LocalSettings()
