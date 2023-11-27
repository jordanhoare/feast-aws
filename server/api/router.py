from fastapi import APIRouter

from server.api.endpoints import features, materialize, projects, registry

router = APIRouter()

router.include_router(features.router, prefix="/features", tags=["features"])
router.include_router(projects.router, prefix="/projects", tags=["projects"])
router.include_router(registry.router, prefix="/registry", tags=["registry"])
router.include_router(materialize.router, prefix="/materialize", tags=["materialize"])
