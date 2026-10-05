-- A room is a concrete inventory item in a specific hotel.
-- The hotel_id and room_type_id link each room to a real property and a shared
-- room category, while the room_number identifies the physical room within that hotel.
--
-- The unique constraint prevents a hotel from having duplicate room numbers.
-- This is important because room numbers must be unique within a property to avoid
-- confusion for guests, staff, and housekeeping.

CREATE TABLE IF NOT EXISTS rooms (
    -- Unique room identifier.
    id SERIAL PRIMARY KEY,

    -- Hotel that owns this room.
    hotel_id INTEGER NOT NULL REFERENCES hotels(id) ON DELETE CASCADE,

    -- Room template used by this room.
    room_type_id INTEGER NOT NULL REFERENCES room_types(id) ON DELETE RESTRICT,

    -- The visible room number such as 101 or 305.
    room_number VARCHAR(20) NOT NULL,

    -- Status of the room in the inventory.
    status VARCHAR(20) NOT NULL DEFAULT 'available' CHECK (status IN ('available', 'occupied', 'maintenance', 'out_of_service')),

    -- When the room was created in the system.
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    UNIQUE (hotel_id, room_number)
);

-- Room queries are usually filtered by hotel and by room type.
-- This index supports common booking and inventory screens.
CREATE INDEX IF NOT EXISTS idx_rooms_hotel_id ON rooms (hotel_id);
CREATE INDEX IF NOT EXISTS idx_rooms_room_type_id ON rooms (room_type_id);
