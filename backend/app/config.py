"""Application configuration for local development.

This file intentionally contains only the environment-driven configuration contract.
It does not yet implement application logic or database access.
"""

from __future__ import annotations

from dataclasses import dataclass
from os import getenv


@dataclass(frozen=True)
class Settings:
    """Runtime configuration for the backend."""

    app_env: str = getenv("APP_ENV", "development")
    postgres_host: str = getenv("POSTGRES_HOST", "localhost")
    postgres_port: int = int(getenv("POSTGRES_PORT", "5432"))
    postgres_db: str = getenv("POSTGRES_DB", "nest")
    postgres_user: str = getenv("POSTGRES_USER", "nest_user")
    postgres_password: str = getenv("POSTGRES_PASSWORD", "nestpass")
    postgres_sslmode: str = getenv("POSTGRES_SSLMODE", "disable")
    jwt_secret: str = getenv("JWT_SECRET", "change_me")


settings = Settings()
