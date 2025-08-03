import os
from pydantic import Field
from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    SECRET_KEY: str = "your-very-secret-key"
    PASSWORD_RESET_TOKEN_EXPIRES: int = 3600  # 1 hour
    BASE_URL: str = "http://localhost:8000"
    MONGO_URI: str = Field(default=...)
    MONGO_DB: str = Field(default=...)
    REFRESH_TOKEN_EXPIRE_DAYS: int = 7
    ACCESS_TOKEN_EXPIRE_MINUTES: int = 30
    JWT_ALGORITHM: str = "HS256"
    JWT_SECRET: str = Field(default=...)
    ENV: str = Field(default="development")
    model_config = SettingsConfigDict(env_file=".env", case_sensitive=True)
    model_config = SettingsConfigDict(env_file=".env", case_sensitive=True)


settings = Settings()
