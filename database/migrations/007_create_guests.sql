-- Guests represent the people staying at the hotel.
-- A guest record is separate from a user account because a guest may be a traveler
-- without an account, or a user may book for people who are not their own account.
--
-- The reservation_id link is not included here because a guest can appear on many
-- reservations over time. This makes the guest table a reusable person directory.

CREATE TABLE IF NOT EXISTS guests (
    -- Unique guest identifier.
    id SERIAL PRIMARY KEY,

    -- Guest's first name as it appears on booking records.
    first_name VARCHAR(100) NOT NULL,

    -- Guest's last name as it appears on booking records.
    last_name VARCHAR(100) NOT NULL,

    -- Guest email is sometimes used for communication but is optional.
    email VARCHAR(255),

    -- Guest phone number for contact or check-in support.
    phone VARCHAR(50),

    -- The date this guest record was created.
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Guest search is usually by name or email, especially for check-in and support.
CREATE INDEX IF NOT EXISTS idx_guests_last_name ON guests (last_name);
CREATE INDEX IF NOT EXISTS idx_guests_email ON guests (email);
