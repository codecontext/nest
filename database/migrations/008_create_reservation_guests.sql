-- A reservation can include multiple guests, and a guest can appear on multiple
-- reservations over time. This join table captures that many-to-many relationship
-- without repeating the guest identity in every reservation row.

CREATE TABLE IF NOT EXISTS reservation_guests (
    -- Unique link record for a guest on a reservation.
    id SERIAL PRIMARY KEY,

    -- Reservation that this guest belongs to.
    reservation_id INTEGER NOT NULL REFERENCES reservations(id) ON DELETE CASCADE,

    -- Guest participating in the reservation.
    guest_id INTEGER NOT NULL REFERENCES guests(id) ON DELETE RESTRICT,

    -- Optional guest type, such as adult, child, or primary contact.
    guest_type VARCHAR(50) DEFAULT 'guest',

    -- When the guest was linked to the reservation.
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    UNIQUE (reservation_id, guest_id)
);

-- These lookups are common in check-in and guest-management workflows.
CREATE INDEX IF NOT EXISTS idx_reservation_guests_reservation_id ON reservation_guests (reservation_id);
CREATE INDEX IF NOT EXISTS idx_reservation_guests_guest_id ON reservation_guests (guest_id);
