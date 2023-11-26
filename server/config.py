from functools import lru_cache
from typing import Optional

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
    REGISTRY_FILE: str = "registry.pb"

    AWS_REGION: str = "ap-southeast-2"
    AWS_ACCESS_KEY_ID: Optional[str] = None
    AWS_SECRET_ACCESS_KEY: Optional[str] = None
    AWS_SESSION_TOKEN: Optional[str] = None

    class Config:
        env_file = ".env"
        env_file_encoding = "utf-8"


@lru_cache
def get_settings() -> LocalSettings:
    return LocalSettings()


settings = get_settings()
