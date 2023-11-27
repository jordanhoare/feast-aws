from pathlib import Path

import boto3
from botocore.exceptions import ClientError, NoCredentialsError
from fastapi import FastAPI, Request
from fastapi.encoders import jsonable_encoder
from fastapi.exceptions import RequestValidationError
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse
from feast import FeatureStore

from server.api.router import router
from server.config import settings


def fetch_registry_from_s3(bucket_name, object_name, local_file_path):
    """Download a file from S3 and save it locally."""
    s3_client = boto3.client("s3")
    try:
        s3_client.download_file(bucket_name, object_name, local_file_path)
    except NoCredentialsError:
        print("Credentials not available")
        raise
    except ClientError as e:
        print(f"An error occurred: {e}")
        raise


def create_api():
    api = FastAPI()
    api.include_router(router)

    api.add_middleware(
        CORSMiddleware,
        allow_origins=["*"],
        allow_credentials=True,
        allow_methods=["*"],
        allow_headers=["*"],
    )

    @api.on_event("startup")
    async def startup_event() -> None:
        fetch_registry_from_s3(
            bucket_name="feast-workshop-sandbox",
            object_name=settings.REGISTRY_FILE,
            local_file_path=settings.LOCAL_REGISTRY_PATH,
        )

        # Initialise the FeatureStore instance from the `feature_store.yml`
        current_file_path = Path(__file__).resolve()
        repository_path = current_file_path.parents[1] / "repository"
        api.state.feature_store = FeatureStore(repository_path)

    @api.exception_handler(RequestValidationError)
    async def value_exception_handler(request: Request, exc: RequestValidationError):
        return JSONResponse(
            status_code=406,
            content={"message": jsonable_encoder(exc.errors()[0])["msg"]},
        )

    @api.on_event("shutdown")
    async def shutdown_event() -> None:
        pass

    return api
