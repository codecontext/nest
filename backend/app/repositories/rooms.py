"""Room data access logic.

This repository focuses on room inventory and room type data. It is intentionally
small and read-focused so we can learn the database shape before adding API routes.
"""

from __future__ import annotations

from typing import Any

from ..db import get_connection


def list_rooms_by_hotel(hotel_id: int) -> list[dict[str, Any]]:
    """Return rooms for a hotel, with their room type and status."""
    with get_connection() as conn:
        with conn.cursor() as cur:
            cur.execute(
                """
                SELECT
                    r.id,
                    r.hotel_id,
                    r.room_type_id,
                    rt.name AS room_type_name,
                    r.room_number,
                    r.status,
                    rt.capacity,
                    rt.base_price,
                    r.created_at
                FROM rooms r
                JOIN room_types rt ON rt.id = r.room_type_id
                WHERE r.hotel_id = %s
                ORDER BY r.room_number
                """,
                (hotel_id,),
            )
            rows = cur.fetchall()

    return [
        {
            "id": row[0],
            "hotel_id": row[1],
            "room_type_id": row[2],
            "room_type_name": row[3],
            "room_number": row[4],
            "status": row[5],
            "capacity": row[6],
            "base_price": row[7],
            "created_at": row[8],
        }
        for row in rows
    ]
