-- Room types define the reusable templates for rooms in a hotel.
-- Instead of repeating pricing and capacity details on every room row,
-- each room can point to one room type and inherit the shared attributes.
--
-- The hotel_id column keeps the room type scoped to one hotel. This avoids
-- a global room type catalog that would be misleading for different properties.
-- The name and capacity are required because guests need a clear description and
-- a predictable room layout when browsing availability.

CREATE TABLE IF NOT EXISTS room_types (
    -- Unique room type identifier.
    id SERIAL PRIMARY KEY,

    -- The hotel that owns this room type.
    hotel_id INTEGER NOT NULL REFERENCES hotels(id) ON DELETE CASCADE,

    -- Human-readable name such as 'Deluxe King' or 'Family Suite'.
    name VARCHAR(100) NOT NULL,

    -- Maximum number of guests allowed in this room type.
    capacity INTEGER NOT NULL CHECK (capacity > 0),

    -- Base nightly price for this room type.
    base_price NUMERIC(10,2) NOT NULL CHECK (base_price >= 0),

    -- Time when this room type was created.
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    -- One room type name may be reused by different hotels,
    -- so the pair (hotel_id, name) is unique within a hotel.
    UNIQUE (hotel_id, name)
);

-- Hotel staff often filter room types by hotel when editing inventory.
-- This index keeps those lookups efficient.
CREATE INDEX IF NOT EXISTS idx_room_types_hotel_id ON room_types (hotel_id);
