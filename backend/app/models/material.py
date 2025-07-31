import datetime
from typing import Optional

from beanie import Document
from pydantic import Field


class Material(Document):
    title: str
    description: Optional[str]
    file_url: Optional[str]         
    material_type: str     # "polycopie" or "book"
    price_dzd: float      
    created_at: datetime = Field(default_factory=datetime.utcnow)
    
    