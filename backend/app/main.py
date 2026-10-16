"""FastAPI application entry point.

This is the first HTTP application layer. It exposes a health endpoint and a
minimal hotels endpoint backed by the repository layer we already created.
"""

from __future__ import annotations

from fastapi import FastAPI

from .repositories.hotels import list_hotels

app = FastAPI(title="nest API", version="0.1.0")


@app.get("/health")
def health_check() -> dict[str, str]:
    """Return a simple health response for the running backend."""
    return {"status": "ok"}


@app.get("/hotels")
def get_hotels() -> list[dict[str, object]]:
    """Return all hotels from PostgreSQL in a simple JSON-friendly payload."""
    return list_hotels()
