# Task Manager

A full-stack task management application built as a **learning project** for exploring Flutter (mobile) and a TypeScript-based REST API backend. It is a personal/educational project — nothing production-grade, just a playground to learn.

## What's Inside

This is a monorepo with two parts:

- **`app/`** — a Flutter mobile application (Dart).
- **`backend/`** — a REST API (Node.js + TypeScript + Express + Drizzle ORM + PostgreSQL), containerized with Docker.

**Status of features:**
- The backend exposes an **auth** module (signup, login, and a protected "me" endpoint) using JWT.
- The mobile app has an **auth feature** built out — signup and login screens (UI + client-side validation), a shared custom theme, and a reusable keyboard-safe scroll widget. The UI is wired up, but the screens aren't connected to the backend API yet.

---

## Technologies & Dependencies

### Backend (`backend/`)

**Runtime dependencies**

| Package | Purpose |
|---|---|
| `express` | Web framework for building the REST API. |
| `pg` | PostgreSQL client (node-postgres) that connects to the database. |
| `drizzle-orm` | Lightweight, typed ORM/query builder for structuring DB access. |
| `jsonwebtoken` | Issues and verifies JWT tokens for authentication. |
| `dotenv` | Loads environment variables from the `.env` file. |

**Development dependencies**

| Package | Purpose |
|---|---|
| `typescript` | Static typing on top of JavaScript. |
| `tsx` | Runs `.ts` files directly in dev (TypeScript execution). |
| `nodemon` | Auto-restarts the server when `src/` files change. |
| `drizzle-kit` | Drizzle migration and schema generation tooling. |
| `bcryptjs` | Hashes passwords for storage. |
| `@types/express` | TypeScript type definitions for Express. |
| `@types/node` | TypeScript type definitions for Node.js. |
| `@types/pg` | TypeScript type definitions for `pg`. |
| `@types/jsonwebtoken` | TypeScript type definitions for `jsonwebtoken`. |

**Package manager:** `pnpm` (v10.27.0, pinned via `packageManager`).

### Mobile App (`app/`)

For a Flutter/Dart project.

- **Flutter** — the UI framework (with `cupertino_icons` and `google_fonts` dependencies).
- **Dev/analysis:** `flutter_test` and `flutter_lints`.

---

## Folder Structure & Organization

```
task-manager/
├── app/                      # Flutter mobile app
│   ├── lib/
│   │   ├── main.dart         # App entry point (MaterialApp)
│   │   ├── themes.dart       # Global theme (Google Fonts, black color scheme)
│   │   ├── extension.dart    # BuildContext extensions (e.g. context.navigator)
│   │   ├── features/         # Feature-based organization
│   │   │   └── auth/         # Auth feature
│   │   │       ├── pages/     # Screen widgets (signup_page, login_page)
│   │   │       └── form_validations.dart  # Shared field validation helpers
│   │   └── widgets/          # Reusable widgets (e.g. keyboard_safe_scroll)
│   └── pubspec.yaml          # Flutter / Dart dependencies
│
├── backend/                  # REST API
│   ├── src/
│   │   ├── controllers/      # Route handlers (e.g. auth.controller.ts)
│   │   ├── db/               # DB connection + Drizzle schemas
│   │   │   └── schemas/      # Table definitions (e.g. users.ts)
│   │   ├── middlewares/      # Express middleware (e.g. auth.middleware.ts)
│   │   ├── routes/           # API route definitions (e.g. auth.route.ts)
│   │   ├── utils/            # Helpers (JWT, password hashing)
│   │   └── index.ts          # App entry point (Express server)
│   │
│   ├── Dockerfile            # Builds the backend image
│   ├── docker-compose.yml    # Spins up backend + PostgreSQL
│   ├── drizzle.config.ts     # Drizzle CLI config (schema/migration paths)
│   ├── tsconfig.json         # TypeScript compiler config
│   ├── package.json          # Backend dependencies & scripts
│   ├── pnpm-lock.yaml        # Locked dependency versions
│   └── .env                  # Local environment variables (NEVER commit)
│
├── .gitignore                # Ignored files (node_modules, dist, .env, ...)
└── README.md                 # This file
```

**Backend organization pattern:** the API follows a clean-ish separation — `routes` define the URL paths, `controllers` hold the business logic, `middlewares` handle auth/validation, and `db/` owns all database concerns. Entry point is `backend/src/index.ts`.

---

## Required Secrets / Environment Variables

Create `backend/.env`. The backend reads these during startup:

| Variable | Description | Example |
|---|---|---|
| `PORT` | Port the API listens on. | `8000` |
| `DATABASE_URL` | Full PostgreSQL connection string. | `postgresql://postgres:postgres@db:5432/mydb` |
| `JWT_SECRET` | Secret used to sign/verify JWTs. Use a long random string. | `a-long-random-string` |
| `POSTGRES_HOST` | DB host (used by drizzle-kit migrations). | `localhost` |
| `POSTGRES_DB` | Database name. | `mydb` |
| `POSTGRES_USER` | DB user. | `postgres` |
| `POSTGRES_PASSWORD` | DB password. | `postgres` |

> **Important:** `.env` is git-ignored and must never be committed. If you clone the repo, create your own `.env` using the example values above (and change `JWT_SECRET` to your own value in real use).

---

## Running Locally

### Prerequisites

- [Docker](https://www.docker.com/) + Docker Compose (recommended, easiest way to run backend + DB).
- For local (non-Docker) backend runs: Node.js 22+, `pnpm`, and a PostgreSQL instance.
- For the Flutter app: Flutter SDK.

### Option A — Run the backend with Docker (recommended)

From the `backend/` folder:

```bash
# Start both the API (port 8000) and PostgreSQL (port 5432)
docker compose up --build
```

Then hit `http://localhost:8000/` — you should see `Hello, World!`.

The users/other tables are managed by Drizzle. To create/apply migrations against the running DB, use drizzle-kit (see below).

### Option B — Run the backend locally (without Docker)

```bash
cd backend
pnpm install

# Make sure a PostgreSQL server is running and .env points to it,
# then run the dev server with auto-reload:
pnpm dev
```

If you want to compile TypeScript to `dist/`:

```bash
pnpm build
```

### Option C — Run the Flutter app

From the `app/` folder with a connected device/emulator:

```bash
flutter pub get
flutter run
```

### Drizzle migrations

From the `backend/` folder:

```bash
# Generate a migration from your schema
pnpm drizzle-kit generate

# Push the schema directly to the DB (quick dev workflow)
pnpm drizzle-kit push
```

---

## API Endpoints (so far)

| Method | Path | Description | Auth |
|---|---|---|---|
| `POST` | `/auth/signup` | Create a new user account. | No |
| `POST` | `/auth/login` | Log in and receive a JWT. | No |
| `GET` | `/auth/me` | Get the current logged-in user. | Yes (Bearer token) |

---

