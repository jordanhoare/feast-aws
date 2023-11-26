from datetime import datetime, timedelta
from typing import List, Optional

from pydantic import BaseModel, Field


class MaterializeRequest(BaseModel):
    start_ts: str = Field(
        default_factory=lambda: (datetime.utcnow() - timedelta(hours=12)).isoformat()
    )
    end_ts: str = Field(
        default_factory=lambda: (datetime.utcnow() - timedelta(minutes=10)).isoformat()
    )
    feature_views: Optional[List[str]] = None
