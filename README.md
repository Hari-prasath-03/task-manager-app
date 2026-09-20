# Task Manager

A full-stack task management application built as a **learning project** for exploring Flutter (mobile) and a TypeScript-based REST API backend. It is a personal/educational project — nothing production-grade, just a playground to learn.

## What's Inside

This is a monorepo with two parts:

- **`app/`** — a Flutter mobile application (Dart).
- **`backend/`** — a REST API (Node.js + TypeScript + Express + Drizzle ORM + PostgreSQL), containerized with Docker.

**Status of features:**
- The backend exposes an **auth** module (signup, login, and a protected "me" endpoint) using JWT, and a **task** module (CRUD operations — create, list, update, delete) with all routes protected.
- The mobile app has **auth** and **task management** features fully wired to the backend API. Auth includes signup/login screens with form validation. Task management includes a home page with weekly date filtering, a task creation form with color picker, and colored task cards. State management uses the Cubit pattern (flutter_bloc), with offline-first caching via SQLite.

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
- **flutter_bloc** — state management via the Cubit pattern.
- **dio** — HTTP client for API communication.
- **sqflite** — local SQLite database for offline data caching.
- **get_it** — service locator for dependency injection.
- **intl** — date/time formatting.
- **flex_color_picker** — color picker widget for task creation.
- **Dev/analysis:** `flutter_test` and `flutter_lints`.

---

## Folder Structure & Organization

```
task-manager/
├── app/                          # Flutter mobile app
│   ├── lib/
│   │   ├── main.dart             # App entry point (MultiBlocProvider)
│   │   ├── themes.dart           # Global theme + AppColors (Google Fonts, Cera Pro)
│   │   ├── extension.dart        # BuildContext extensions
│   │   │
│   │   ├── core/                 # Shared infrastructure
│   │   │   ├── di/               # Dependency injection (get_it)
│   │   │   │   └── injection_container.dart
│   │   │   ├── network/          # HTTP client (Dio singleton)
│   │   │   │   └── dio_client.dart
│   │   │   ├── services/         # Shared services (SharedPreferences)
│   │   │   │   └── sp_service.dart
│   │   │   ├── utils/            # Helpers (validation, date gen, hex/color)
│   │   │   │   └── utils.dart
│   │   │   └── widgets/          # Reusable widgets (keyboard_safe_scroll)
│   │   │
│   │   └── features/
│   │       ├── auth/             # Authentication feature
│   │       │   ├── cubit/        # AuthCubit + AuthState
│   │       │   ├── data/repository/  # AuthRemoteRepository + AuthLocalRepository
│   │       │   ├── domain/       # UserModel
│   │       │   └── presentation/pages/  # login_page, signup_page
│   │       │
│   │       └── home/             # Task management feature
│   │           ├── cubit/        # TaskCubit + TaskState
│   │           ├── data/repository/  # TaskRemoteRepository + TaskLocalRepository
│   │           ├── domain/       # TaskModel
│   │           └── presentation/
│   │               ├── pages/    # home_page, add_new_task_page
│   │               └── widgets/  # date_selector, task_card
│   │
│   ├── assets/fonts/             # Cera Pro font files
│   └── pubspec.yaml
│
├── backend/                      # REST API
│   ├── src/
│   │   ├── controllers/          # Route handlers (auth, task)
│   │   ├── db/
│   │   │   ├── schemas/          # Drizzle table definitions (users, tasks)
│   │   │   └── index.ts          # DB connection
│   │   ├── middlewares/          # Express middleware (auth)
│   │   ├── routes/               # API routes (auth, task)
│   │   ├── utils/                # Helpers (JWT, password hashing, truncate)
│   │   └── index.ts              # App entry point (Express server)
│   │
│   ├── Dockerfile
│   ├── docker-compose.yml
│   ├── drizzle.config.ts
│   ├── tsconfig.json
│   ├── package.json
│   ├── pnpm-lock.yaml
│   └── .env
│
├── .gitignore
└── README.md
```

**Backend organization pattern:** the API follows a clean separation — `routes` define the URL paths, `controllers` hold the business logic, `middlewares` handle auth/validation, and `db/` owns all database concerns (schemas are split per-table in `db/schemas/`). Entry point is `backend/src/index.ts`.

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
| `POST` | `/tasks` | Create a new task. | Yes (Bearer token) |
| `GET` | `/tasks` | List all tasks for the logged-in user. | Yes (Bearer token) |
| `PUT` | `/tasks/:id` | Update a task by ID. | Yes (Bearer token) |
| `DELETE` | `/tasks/:id` | Delete a task by ID. | Yes (Bearer token) |

---

## Architecture

The Flutter app follows a **feature-based layered architecture**:

- **`core/`** — shared infrastructure: dependency injection (`get_it`), networking (`Dio` singleton), services (`SharedPreferences`), utilities, and reusable widgets.
- **`features/<name>/`** — each feature is self-contained with:
  - `cubit/` — state management using the Cubit pattern (`flutter_bloc`).
  - `data/repository/` — paired local (SQLite) and remote (Dio) data sources.
  - `domain/` — data models.
  - `presentation/` — pages and widgets.

**Data flow:** Pages consume Cubit states via `BlocBuilder`/`BlocConsumer`. Cubits call repositories, which attempt remote API calls first and fall back to local SQLite cache when offline. All service registration is centralized in `injection_container.dart` via `get_it`.

The backend follows a clean separation: `routes` define URL paths, `controllers` hold business logic, `middlewares` handle auth, and `db/` owns all database concerns. Drizzle schemas are organized per-table in `db/schemas/`.

