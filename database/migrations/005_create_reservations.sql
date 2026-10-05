-- Reservations are the core booking records in the application.
-- They connect a guest user to a specific room and a date range, and they
-- represent the actual act of booking rather than just room availability.
--
-- A reservation does not mean payment is complete; it only means the stay was
-- requested and accepted under a certain status. This keeps the payment flow
-- separate from the reservation lifecycle.

CREATE TABLE IF NOT EXISTS reservations (
    -- Unique reservation identifier.
    id SERIAL PRIMARY KEY,

    -- User who created the reservation.
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE RESTRICT,

    -- Hotel that owns the booked room.
    hotel_id INTEGER NOT NULL REFERENCES hotels(id) ON DELETE CASCADE,

    -- Specific room reserved for this stay.
    room_id INTEGER NOT NULL REFERENCES rooms(id) ON DELETE RESTRICT,

    -- Check-in date for the reservation.
    check_in_date DATE NOT NULL,

    -- Check-out date; it must be after the check-in date.
    check_out_date DATE NOT NULL,

    -- Number of guests included in the reservation.
    guest_count INTEGER NOT NULL CHECK (guest_count > 0),

    -- Booking status at the current stage of the lifecycle.
    status VARCHAR(20) NOT NULL DEFAULT 'PENDING' CHECK (status IN ('PENDING', 'CONFIRMED', 'CHECKED_IN', 'CHECKED_OUT', 'CANCELLED', 'NO_SHOW')),

    -- Final reservation total before payment processing.
    total_amount NUMERIC(10,2) NOT NULL CHECK (total_amount >= 0),

    -- When the reservation was created.
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    -- A room cannot be booked for overlapping date ranges by the same room.
    -- This is handled in the application and in later PostgreSQL availability logic.
    CHECK (check_out_date > check_in_date)
);

-- Reservation screens commonly filter by user, room, or hotel.
-- These indexes keep access fast for booking history and occupancy queries.
CREATE INDEX IF NOT EXISTS idx_reservations_user_id ON reservations (user_id);
CREATE INDEX IF NOT EXISTS idx_reservations_hotel_id ON reservations (hotel_id);
CREATE INDEX IF NOT EXISTS idx_reservations_room_id ON reservations (room_id);
CREATE INDEX IF NOT EXISTS idx_reservations_dates ON reservations (room_id, check_in_date, check_out_date);
