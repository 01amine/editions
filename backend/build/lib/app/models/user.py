from enum import Enum
from beanie import Document
from pydantic import BaseModel, Field, EmailStr, field_validator
from datetime import datetime
from typing import Optional, List


class Role(str, Enum):
    Super_Admin = "super_admin"
    USER = "user"
    ADMIN = "admin"


class User(Document):
    email: EmailStr = Field(unique=True)
    hashed_password: str
    isblocked : bool = False
    full_name: Optional[str]
    phone_number: Optional[str]
    study_year: Optional[str] = None
    specialite: Optional[str] = None
    roles: List[Role] = [Role.USER]
    created_at: datetime = Field(default_factory=datetime.utcnow)


class UserCreate(BaseModel):
    email : str
    full_name: str
    phone_number: str
    password: str
    study_year: Optional[str] = None
    specialite: Optional[str] = None
    
    
class UserLogin(BaseModel):
    email: str
    password: str

class ForgotPasswordRequest(BaseModel):
    email: EmailStr
    
class ResetPasswordRequest(BaseModel):
    token: str
    new_password: str