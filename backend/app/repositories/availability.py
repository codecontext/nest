"""Availability data access logic.

This repository wraps the PostgreSQL availability function we created earlier.
It keeps the date-range room search in the data layer and leaves routing and
business validation for later.
"""

from __future__ import annotations

from datetime import date
from typing import Any

from ..db import get_connection


def find_available_rooms(hotel_id: int, check_in: date, check_out: date) -> list[dict[str, Any]]:
    """Return rooms available for the requested date range in a hotel."""
    with get_connection() as conn:
        with conn.cursor() as cur:
            cur.execute(
                """
                SELECT room_id, room_number, hotel_id, room_type_id, status
                FROM get_available_rooms_for_range(%s, %s, %s)
                ORDER BY room_number
                """,
                (hotel_id, check_in, check_out),
            )
            rows = cur.fetchall()

    return [
        {
            "room_id": row[0],
            "room_number": row[1],
            "hotel_id": row[2],
            "room_type_id": row[3],
            "status": row[4],
        }
        for row in rows
    ]
