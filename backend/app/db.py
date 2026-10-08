"""Database connection helpers for the backend.

This file keeps PostgreSQL access separate from API logic and business rules.
At this stage it is intentionally small and focused on the connection contract.
"""

from __future__ import annotations

import psycopg

from .config import settings


def get_connection():
    """Return a PostgreSQL connection configured from environment settings."""
    return psycopg.connect(
        host=settings.postgres_host,
        port=settings.postgres_port,
        dbname=settings.postgres_db,
        user=settings.postgres_user,
        password=settings.postgres_password,
        sslmode=settings.postgres_sslmode,
    )
