import datetime
from typing import List, Optional

from beanie import Document
from pydantic import Field


class Material(Document):
    title: str
    description: Optional[str]
    image_urls: List[str] = []
    material_type: str     # "polycopie" or "book"
    price_dzd: float 
    pdf_url: Optional[str]     
    created_at: datetime = Field(default_factory=datetime.utcnow)
    
    
    