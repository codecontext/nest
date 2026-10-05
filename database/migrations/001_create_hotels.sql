-- A hotel is the top-level business entity in this application.
-- Each hotel represents one physical property and owns the rooms, inventory,
-- and reservations associated with that location.
--
-- The primary key gives every hotel a stable identity that other tables can
-- reference through foreign keys as the system grows.
-- The name, city, and country fields are required because hotel discovery is
-- usually driven by location and a recognizable property name.

CREATE TABLE IF NOT EXISTS hotels (
    -- Unique hotel identifier used by other tables.
    id SERIAL PRIMARY KEY,

    -- Hotel display name shown to guests and staff.
    name VARCHAR(150) NOT NULL,

    -- City where the hotel is located.
    city VARCHAR(100) NOT NULL,

    -- Country for hotel location and search filtering.
    country VARCHAR(100) NOT NULL,

    -- When this hotel record was created.
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Searches by destination are common in hotel applications.
-- Indexing the city column keeps those lookups fast without needing a full
-- table scan when a user browses hotels in a region.
CREATE INDEX IF NOT EXISTS idx_hotels_city ON hotels (city);
