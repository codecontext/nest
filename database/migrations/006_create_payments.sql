-- Payments are separate from reservations.
-- A reservation is a booking request and lifecycle record; a payment is a financial
-- transaction tied to that reservation. This split is important because a booking
-- can exist without a successful payment, and a payment can be refunded or fail.

CREATE TABLE IF NOT EXISTS payments (
    -- Unique payment identifier.
    id SERIAL PRIMARY KEY,

    -- Reservation this payment belongs to.
    reservation_id INTEGER NOT NULL REFERENCES reservations(id) ON DELETE CASCADE,

    -- Payment status from the lifecycle of the transaction.
    status VARCHAR(20) NOT NULL DEFAULT 'PENDING' CHECK (status IN ('PENDING', 'AUTHORIZED', 'PAID', 'FAILED', 'REFUNDED')),

    -- Amount charged to the guest for this payment event.
    amount NUMERIC(10,2) NOT NULL CHECK (amount >= 0),

    -- Payment provider reference for later integration with a real gateway.
    provider_reference VARCHAR(255),

    -- The provider used for this payment attempt.
    provider VARCHAR(100) NOT NULL DEFAULT 'SIMULATED',

    -- When the payment record was created.
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    -- A reservation should have a payment record that matches its lifetime, but the
    -- database does not force a single successful payment here.
    UNIQUE (reservation_id, provider_reference)
);

-- Payment queries are usually filtered by reservation or status.
-- These indexes support the common payment review screens.
CREATE INDEX IF NOT EXISTS idx_payments_reservation_id ON payments (reservation_id);
CREATE INDEX IF NOT EXISTS idx_payments_status ON payments (status);
