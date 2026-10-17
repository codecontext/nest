"""FastAPI application entry point.

This is the first HTTP application layer. It exposes a health endpoint and a
minimal hotels endpoint backed by the repository layer we already created.
"""

from __future__ import annotations

from fastapi import FastAPI

from .repositories.hotels import list_hotels
from .repositories.reservations import list_reservations_for_user
from .repositories.rooms import list_rooms_by_hotel

app = FastAPI(title="nest API", version="0.1.0")


@app.get("/health")
def health_check() -> dict[str, str]:
    """Return a simple health response for the running backend."""
    return {"status": "ok"}


@app.get("/hotels")
def get_hotels() -> list[dict[str, object]]:
    """Return all hotels from PostgreSQL in a simple JSON-friendly payload."""
    return list_hotels()


@app.get("/hotels/{hotel_id}/rooms")
def get_hotel_rooms(hotel_id: int) -> list[dict[str, object]]:
    """Return room inventory for one hotel from PostgreSQL."""
    return list_rooms_by_hotel(hotel_id)


@app.get("/users/{user_id}/reservations")
def get_user_reservations(user_id: int) -> list[dict[str, object]]:
    """Return reservations for a user with hotel and room context."""
    return list_reservations_for_user(user_id)
