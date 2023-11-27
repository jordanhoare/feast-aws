from datetime import datetime, timedelta
from typing import Any, Dict, List, Optional

from pydantic import BaseModel, Field


class MaterializeRequest(BaseModel):
    start_ts: str = Field(
        default_factory=lambda: (datetime.utcnow() - timedelta(hours=12)).isoformat()
    )
    end_ts: str = Field(
        default_factory=lambda: (datetime.utcnow() - timedelta(minutes=10)).isoformat()
    )
    feature_views: Optional[List[str]] = None


class GetOnlineFeaturesRequest(BaseModel):
    features: List[str]  # Assuming features are provided as a list of strings
    entity_values: Dict[str, List[Any]]  # Mapping of entity names to their values
    full_feature_names: bool = False
