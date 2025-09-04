import os
from pydantic import Field
from pydantic_settings import BaseSettings, SettingsConfigDict
from fastapi_mail import ConnectionConfig

class Settings(BaseSettings):
    MINIO_HOST: str = "127.0.0.1"
    MINIO_PORT: int = 9000
    MINIO_ROOT_USER: str = "minioadmin"
    MINIO_ROOT_PASSWORD: str = "crptx123"
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
    MAILJET_API_KEY: str
    MAILJET_SECRET_KEY: str
    MAIL_FROM_ADDRESS: str
    ZR_EXPRESS_TOKEN: str
    ZR_EXPRESS_KEY: str
    model_config = SettingsConfigDict(env_file=".env", case_sensitive=True)

settings = Settings()

conf = ConnectionConfig(
    MAIL_USERNAME=settings.MAILJET_API_KEY,
    MAIL_PASSWORD=settings.MAILJET_SECRET_KEY,
    MAIL_FROM=settings.MAIL_FROM_ADDRESS,
    MAIL_PORT=587,
    MAIL_SERVER="in-v3.mailjet.com",
    MAIL_STARTTLS=True,
    MAIL_SSL_TLS=False,
    USE_CREDENTIALS=True,
)