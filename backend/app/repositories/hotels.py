"""Hotel data access logic.

This repository is intentionally minimal and focused on a read operation that
matches the hotel table we created earlier in PostgreSQL.
"""

from __future__ import annotations

from typing import Any

from ..db import get_connection


def list_hotels() -> list[dict[str, Any]]:
    """Return all hotels in the database ordered by city and name."""
    with get_connection() as conn:
        with conn.cursor() as cur:
            cur.execute(
                """
                SELECT id, name, city, country, created_at
                FROM hotels
                ORDER BY city, name
                """
            )
            rows = cur.fetchall()

    return [
        {
            "id": row[0],
            "name": row[1],
            "city": row[2],
            "country": row[3],
            "created_at": row[4],
        }
        for row in rows
    ]
