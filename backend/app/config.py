import os
from pydantic import Field
from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    MONGO_URI: str = Field(default=...)
    MONGO_DB: str = Field(default=...)
    CASSANDRA_HOST: str = Field(default=...)
    CASSANDRA_KEYSPACE: str = Field(default=...)
    STRIPE_SECRET_KEY: str = Field(default=...)
    STRIPE_WEBHOOK_SECRET: str = Field(default=...)
    JWT_SECRET: str = Field(default=...)
    ENV: str = Field(default="development")
    model_config = SettingsConfigDict(env_file=".env", case_sensitive=True)
    model_config = SettingsConfigDict(env_file=".env", case_sensitive=True)


settings = Settings()
