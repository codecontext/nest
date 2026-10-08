"""Reservation data access logic.

This repository is focused on reading reservation records and their related room
and user information. It remains intentionally small and clear before any API layer
or booking-business logic is added.
"""

from __future__ import annotations

from typing import Any

from ..db import get_connection


def list_reservations_for_user(user_id: int) -> list[dict[str, Any]]:
    """Return reservations for a given user with room and hotel context."""
    with get_connection() as conn:
        with conn.cursor() as cur:
            cur.execute(
                """
                SELECT
                    r.id,
                    r.hotel_id,
                    h.name AS hotel_name,
                    r.room_id,
                    rm.room_number,
                    r.check_in_date,
                    r.check_out_date,
                    r.guest_count,
                    r.status,
                    r.total_amount,
                    r.created_at
                FROM reservations r
                JOIN hotels h ON h.id = r.hotel_id
                JOIN rooms rm ON rm.id = r.room_id
                WHERE r.user_id = %s
                ORDER BY r.check_in_date DESC
                """,
                (user_id,),
            )
            rows = cur.fetchall()

    return [
        {
            "id": row[0],
            "hotel_id": row[1],
            "hotel_name": row[2],
            "room_id": row[3],
            "room_number": row[4],
            "check_in_date": row[5],
            "check_out_date": row[6],
            "guest_count": row[7],
            "status": row[8],
            "total_amount": row[9],
            "created_at": row[10],
        }
        for row in rows
    ]
