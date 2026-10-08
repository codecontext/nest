-- Seed a small, realistic dataset for availability testing.
-- This is intentionally small and focused: one hotel, one room type, one room,
-- one user, and one reservation that overlaps a future stay window.
--
-- The purpose is to exercise the PostgreSQL availability logic in the same way a
-- real room search would do it, without introducing a large demo dataset.

WITH hotel AS (
    INSERT INTO hotels (name, city, country)
    SELECT 'Harbor View Hotel', 'Lisbon', 'Portugal'
    WHERE NOT EXISTS (
        SELECT 1 FROM hotels WHERE name = 'Harbor View Hotel' AND city = 'Lisbon'
    )
    RETURNING id
),
room_type AS (
    INSERT INTO room_types (hotel_id, name, capacity, base_price)
    SELECT h.id, 'Deluxe King', 2, 180.00
    FROM hotel h
    WHERE NOT EXISTS (
        SELECT 1
        FROM room_types rt
        WHERE rt.hotel_id = h.id AND rt.name = 'Deluxe King'
    )
    RETURNING id, hotel_id
),
room AS (
    INSERT INTO rooms (hotel_id, room_type_id, room_number, status)
    SELECT rt.hotel_id, rt.id, '101', 'available'
    FROM room_type rt
    WHERE NOT EXISTS (
        SELECT 1
        FROM rooms r
        WHERE r.hotel_id = rt.hotel_id AND r.room_number = '101'
    )
    RETURNING id, hotel_id
),
app_user AS (
    INSERT INTO users (email, password_hash, first_name, last_name, role)
    SELECT 'guest@example.com', 'hashed_password_placeholder', 'Alice', 'Guest', 'USER'
    WHERE NOT EXISTS (
        SELECT 1 FROM users WHERE email = 'guest@example.com'
    )
    RETURNING id
)
INSERT INTO reservations (user_id, hotel_id, room_id, check_in_date, check_out_date, guest_count, status, total_amount)
SELECT u.id, r.hotel_id, r.id, DATE '2026-10-15', DATE '2026-10-18', 2, 'CONFIRMED', 540.00
FROM room r
CROSS JOIN app_user u
WHERE NOT EXISTS (
    SELECT 1
    FROM reservations res
    WHERE res.room_id = r.id
      AND res.check_in_date = DATE '2026-10-15'
      AND res.check_out_date = DATE '2026-10-18'
);

-- Optional blocked-date example for the same room.
INSERT INTO room_availability (room_id, date, is_available, reason)
SELECT r.id, DATE '2026-10-20', FALSE, 'Maintenance'
FROM rooms r
WHERE r.room_number = '101'
ON CONFLICT (room_id, date) DO NOTHING;

-- The availability function can now be tested against a real room with an existing
-- reservation and a blocked date.
