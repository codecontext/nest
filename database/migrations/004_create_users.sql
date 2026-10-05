-- Users are the authenticated people who can book rooms or manage a hotel.
-- The password_hash stores only a one-way hash, never a plain-text password.
-- This is the core security rule for any real application and is essential before
-- we build login flows.

CREATE TABLE IF NOT EXISTS users (
    -- Unique user identifier.
    id SERIAL PRIMARY KEY,

    -- Email address used for login and contact. It must be unique to avoid
    -- duplicate accounts for the same person.
    email VARCHAR(255) NOT NULL UNIQUE,

    -- Store only a hashed password; plaintext passwords are never kept in the DB.
    password_hash VARCHAR(255) NOT NULL,

    -- User-visible name used in the application.
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,

    -- The role controls what actions a user is allowed to perform.
    role VARCHAR(20) NOT NULL DEFAULT 'USER' CHECK (role IN ('USER', 'ADMIN')),

    -- When the account was created.
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Authentication flows usually look up a user by email.
-- This index makes that lookup efficient.
CREATE INDEX IF NOT EXISTS idx_users_email ON users (email);
