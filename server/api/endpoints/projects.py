from pydantic import BaseModel
from fastapi import APIRouter

from server.core.logger import logger


class Project(BaseModel):
    name: str
    description: str
    id: str
    registryPath: str


router = APIRouter()


@router.get("")
def get_projects():
    logger.info('Fetching list of projects.')

    projects = [
        Project(
            name="Project",
            description="Project for credit scoring team and associated models.",
            id="feast_demo_aws",
            registryPath="http://localhost:8000/registry"
        )
    ]
    return {"projects": projects}
