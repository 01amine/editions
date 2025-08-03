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
    roles: List[Role] = [Role.USER]
    created_at: datetime = Field(default_factory=datetime.utcnow)


class UserCreate(BaseModel):
    email : str
    full_name: str
    phone_number: str
    password: str
    
class UserLogin(BaseModel):
    email: str
    password: str

class ForgotPasswordRequest(BaseModel):
    email: EmailStr
    
class PasswordReset(BaseModel):
    token: str
    new_password: str
    confirm_password: str

    @field_validator('confirm_password')
    @classmethod
    def passwords_match(cls, v, info):
        if 'new_password' in info.data and v != info.data['new_password']:
            raise ValueError('Passwords do not match')
        return v