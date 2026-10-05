# Database

This project will use PostgreSQL as the source of truth for hotel data.

The database will be managed through small, numbered migration files so each schema change is clear, reviewable, and easy to revert.

## Migration workflow

- Keep migrations small and focused.
- Use a numbered naming pattern such as `001_create_hotels.sql`.
- Commit each schema change separately.
- Avoid creating tables or schema changes in a single large file.

The database itself is not created yet. This folder only prepares the structure for the migration workflow we will use as the application grows.
