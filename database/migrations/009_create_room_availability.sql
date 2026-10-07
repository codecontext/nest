-- Room availability tracks whether a room is open for booking on specific dates.
-- This table is intentionally separate from reservations so the system can reason
-- about blocked dates, maintenance windows, and future availability without mixing
-- them into the reservation records themselves.
--
-- The real booking rule is: a room is unavailable if it already has a reservation
-- that overlaps the requested stay, or if it is marked unavailable for a date.

CREATE TABLE IF NOT EXISTS room_availability (
    -- Unique availability record for one room and one date.
    id SERIAL PRIMARY KEY,

    -- Room whose availability is being tracked.
    room_id INTEGER NOT NULL REFERENCES rooms(id) ON DELETE CASCADE,

    -- Date that this availability record applies to.
    date DATE NOT NULL,

    -- Whether the room is available to book for this date.
    is_available BOOLEAN NOT NULL DEFAULT TRUE,

    -- Optional reason such as maintenance or blocked housekeeping.
    reason VARCHAR(100),

    -- When the availability record was created.
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    -- One room should have at most one availability entry per date.
    UNIQUE (room_id, date)
);

-- Availability queries are frequently filtered by room and date range.
CREATE INDEX IF NOT EXISTS idx_room_availability_room_id ON room_availability (room_id);
CREATE INDEX IF NOT EXISTS idx_room_availability_date ON room_availability (date);
