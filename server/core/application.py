import boto3
from botocore.exceptions import ClientError, NoCredentialsError
from fastapi import FastAPI, Request
from fastapi.encoders import jsonable_encoder
from fastapi.exceptions import RequestValidationError
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse

from server.api.endpoints import features, projects, registry
from server.core.config import get_settings


def create_api():
    api = FastAPI()
    settings = get_settings()

    api.include_router(features.router, prefix="/features", tags=["features"])
    api.include_router(projects.router, prefix="/projects", tags=["projects"])
    api.include_router(registry.router, prefix="/registry", tags=["registry"])

    api.add_middleware(
        CORSMiddleware,
        allow_origins=["*"],
        allow_credentials=True,
        allow_methods=["*"],
        allow_headers=["*"],
    )

    @api.on_event("startup")
    async def startup_event() -> None:
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

        fetch_registry_from_s3(
            bucket_name="feast-workshop-sandbox",
            object_name="registry.pb",
            local_file_path=settings.LOCAL_REGISTRY_PATH,
        )

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
