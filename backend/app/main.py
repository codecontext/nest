"""Minimal FastAPI application entry point.

This is intentionally small and used only to prove the backend can boot and serve
HTTP before we add real hotel, room, and reservation APIs.
"""

from __future__ import annotations

from fastapi import FastAPI

app = FastAPI(title="nest API", version="0.1.0")


@app.get("/health")
def health_check() -> dict[str, str]:
    """Return a simple health response for the running backend."""
    return {"status": "ok"}
