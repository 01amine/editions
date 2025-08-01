# app/models/material.py

from enum import Enum
from beanie import Document
from pydantic import Field
from datetime import datetime
from typing import Literal

class MaterialType(str,Enum):
    book = "book"
    polycopie = "polycopie"
class Material(Document):
    title: str
    description: str
    file_url: str                         # URL to the uploaded PDF or book
    material_type: MaterialType
    price_dzd: float                      # Optional if you plan to use pricing
    created_at: datetime = Field(default_factory=datetime.utcnow)

    class Settings:
        name = "materials"
