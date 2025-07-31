from enum import Enum
from beanie import Document
from pydantic import Field, EmailStr
from datetime import datetime
from typing import Optional, List


class Role(str, Enum):
    USER = "user"
    ADMIN = "admin"


class User(Document):

    email: EmailStr
    hashed_password: str
    full_name: Optional[str]
    is_active: bool = True
    roles: List[Role] = [Role.USER]
    organization_id: Optional[str]
    subscription_active: bool = True
    created_at: datetime = Field(default_factory=datetime.utcnow)
