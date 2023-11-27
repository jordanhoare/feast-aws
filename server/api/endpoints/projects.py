from fastapi import APIRouter
from pydantic import BaseModel

from server.logger import logger


class Project(BaseModel):
    name: str
    description: str
    id: str
    registryPath: str


router = APIRouter()


# TODO: Look to infer the project list from the registry
@router.get("")
def get_projects():
    logger.info("Fetching list of projects.")

    projects = [
        Project(
            name="Project",
            description="\
                Project for credit scoring team and associated models.",
            id="feast_demo_aws",
            registryPath="http://localhost:8000/registry",
        )
    ]
    return {"projects": projects}
