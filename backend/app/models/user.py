from enum import Enum
from beanie import Document
from pydantic import Field, EmailStr
from datetime import datetime
from typing import Optional, List


class Role(str, Enum):
    Super_Admin = "super_admin"
    USER = "user"
    ADMIN = "admin"


class User(Document):
    email: EmailStr
    hashed_password: str
    full_name: Optional[str]
    roles: List[Role] = [Role.USER]
    created_at: datetime = Field(default_factory=datetime.utcnow)
