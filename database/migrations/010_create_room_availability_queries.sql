-- This query teaches the core booking rule for a hotel system:
-- a room is available only when it is not blocked for any date in the requested
-- range and there is no overlapping reservation for that room.
--
-- We keep the logic in PostgreSQL so the database enforces the real business rule,
-- instead of trusting the application layer to do the check correctly.

CREATE OR REPLACE FUNCTION get_available_rooms_for_range(
    p_hotel_id INTEGER,
    p_check_in DATE,
    p_check_out DATE
)
RETURNS TABLE (
    room_id INTEGER,
    room_number VARCHAR(20),
    hotel_id INTEGER,
    room_type_id INTEGER,
    status VARCHAR(20)
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT
        r.id AS room_id,
        r.room_number,
        r.hotel_id,
        r.room_type_id,
        r.status
    FROM rooms r
    WHERE r.hotel_id = p_hotel_id
      AND r.status = 'available'
      AND NOT EXISTS (
          SELECT 1
          FROM reservations res
          WHERE res.room_id = r.id
            AND res.status IN ('PENDING', 'CONFIRMED', 'CHECKED_IN')
            AND res.check_in_date < p_check_out
            AND res.check_out_date > p_check_in
      )
      AND NOT EXISTS (
          SELECT 1
          FROM room_availability ra
          WHERE ra.room_id = r.id
            AND ra.date >= p_check_in
            AND ra.date < p_check_out
            AND ra.is_available = FALSE
      )
    ORDER BY r.room_number;
END;
$$;

-- This function is intentionally small and explicit.
-- It demonstrates the most important PostgreSQL availability pattern:
-- overlap checks on date ranges plus daily blocked dates.
