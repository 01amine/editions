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
    roles: List[Role] = Field(default_factory=lambda: [Role.USER])    
    reset_code: Optional[str] = None
    reset_code_expires: Optional[datetime] = None
    area: str
    created_at: datetime = Field(default_factory=datetime.utcnow)


class UserCreate(BaseModel):
    email : str
    full_name: str
    phone_number: str
    password: str
    study_year: Optional[str] = None
    specialite: Optional[str] = None
    area: str
    
    
class UserLogin(BaseModel):
    email: str
    password: str

class ForgotPasswordRequest(BaseModel):
    email: EmailStr
    
class ResetPasswordRequest(BaseModel):
    email: str
    code: str
    new_password: str
    

class VerifyCodeRequest(BaseModel):
    email: str
    code: str