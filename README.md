# nest

Nest is a locally developed hotel management application and a practical project for learning PostgreSQL and how a web application is built, one layer at a time.

The planned application will let guests browse rooms, check availability for real dates, and manage reservations. Hotel administrators will be able to manage rooms and reservations. Payments will be simulated during development; reservation records and payment records will remain separate.

## Goals

- Learn PostgreSQL by designing and querying a realistic, normalized database.
- Understand how a frontend, backend API, and database work together.
- Keep business rules in the backend and database rather than relying on the browser.
- Grow the application through small, reviewable changes instead of scaffolding everything at once.

## Architecture

The intended request flow is:

```text
Browser -> Web frontend -> Backend REST API -> PostgreSQL
```

The frontend will present the guest and administrator workflows. The backend will expose APIs and enforce application rules. PostgreSQL will store the application's durable data and enforce relationships and constraints. All components are intended to run locally during development; no cloud services are required.

## Technology

The backend will use Python with FastAPI for the REST API and psycopg 3 for PostgreSQL connections. Database queries will initially use parameterized SQL directly rather than an ORM, keeping SQL and PostgreSQL behavior visible while learning. The frontend technology will be chosen separately when frontend work begins.

## Development

Database changes will be recorded as incremental migrations. Each change should focus on one understandable concept or feature and be committed separately, so the Git history documents how the application develops.

## Current status

This repository currently contains only its initial documentation and Git ignore rules. The database, migrations, backend, frontend, and dependencies have not been added yet.