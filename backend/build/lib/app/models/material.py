from typing import List, Optional
import datetime
from beanie import Document, PydanticObjectId
from pydantic import BaseModel, Field


class Material(Document):
    title: str
    study_year: Optional[str]
    specialite : Optional[str] 
    module : Optional[str] = None
    description: Optional[str]
    image_urls: List[str] = []
    material_type: str     # "polycopie" or "book"
    price_dzd: float 
    pdf_url: Optional[str]     
    created_at: datetime.datetime = Field(default_factory=lambda: datetime.datetime.now())
     
    
    class Settings:
        name = "material"
        
class materialUser(BaseModel):
    id: PydanticObjectId = Field(..., alias="_id")
    title: str
    description: Optional[str]
    image_urls: List[str] = []
    material_type: str     # "polycopie" or "book"
    module : Optional[str] = None
    study_year: Optional[str] = None
    specialite: Optional[str] = None
    price_dzd: float 
    created_at: datetime.datetime = Field(default_factory=lambda: datetime.datetime.now())
    model_config = {
        "populate_by_name": True,   
        "from_attributes": True     
    }
    
    