from fastapi import FastAPI, Request
from fastapi.encoders import jsonable_encoder
from fastapi.exceptions import RequestValidationError
from fastapi.responses import JSONResponse

from server.api.endpoints import hello


def create_api():
    api = FastAPI()

    api.include_router(hello.router, prefix="/hello", tags=["hello"])

    @api.on_event("startup")
    async def startup_event() -> None:
        pass

    @api.exception_handler(RequestValidationError)
    async def value_exception_handler(request: Request, exc: RequestValidationError):
        return JSONResponse(
            status_code=406, 
            content={"message": jsonable_encoder(
                exc.errors()[0])["msg"]}
        )

    @api.on_event("shutdown")
    async def shutdown_event() -> None:
        pass

    return api
