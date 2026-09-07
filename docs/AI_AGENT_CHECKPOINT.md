# Pulse Coach Mobile — Authoritative AI Agent Checkpoint

Last updated: 2026-09-07

This is the first document a new coding agent must read. Do not restart the app, replace the architecture, or re-invent contracts from screenshots.

## Source of truth priority

1. Current code on the active Pulse Coach mobile branch.
2. This checkpoint + `ARCHITECTURE.md` + `docs/TEST_STRATEGY.md`.
3. `Hosammar3y/gym-coaching-platform` current source for backend contracts and product rules.
4. `Hosammar3y/gym-coaching-platform-azure`, production branch `deployment/azure-vm-production`, for deployed reference behavior.
5. Approved mobile design handoff for presentation direction.

When documents conflict with backend behavior, investigate and explicitly record the delta. Never silently invent an API.

## Architecture

Feature-first Clean Architecture:

`presentation -> use case/domain -> repository contract -> repository implementation -> remote data source -> ApiClient`

`main.dart` only bootstraps. Riverpod is the single state-management system. go_router is centralized. Dio is centralized. Realtime/SSE belongs in `core/realtime` and notification state belongs in `features/notifications`.

## Permanent phase gate

For every phase N:

`implement N -> unit/widget tests N -> integration tests N -> full regression phases 1..N -> flutter analyze -> CI green -> update checkpoint -> only then start N+1`

Never report a phase complete based on code being present. CI evidence is required.

## Current mobile repository

- Repository: `Hosammar3y/Pulse_Gym_APP`
- Working PR: #1
- Working branch: `feat/phase-0-phase-2-foundation`
- Default branch: `main`

## Phase 0 — Architecture foundation

Scope: bootstrap, app/router/theme, network, secure storage, realtime/SSE boundary, feature-first structure, shared shell, CI.

Current action: analyzer issues from the first CI run are being corrected and regression tests are being added before Phase 3.

## Phase 1 — Auth / Shell / Today

Canonical endpoints used:
- `POST /auth/login`
- `POST /auth/refresh`
- `POST /auth/logout`
- `GET /trainer/profile`
- `GET /trainer/trainees`
- `GET /trainer/checkins`
- `GET /trainer/renewal-requests?status=PENDING`

Mobile supports Trainer accounts. Today shows active clients, waiting reviews, pending renewals, paused/expired counts, recent clients and quick actions. Presence remains a separate realtime capability and is not faked by the Today snapshot.

## Phase 2 — Clients / Client Profile / Baseline

Canonical client endpoints:
- `GET /trainer/trainees`
- `POST /trainer/trainees`
- `GET /trainer/trainees/{id}`
- `PATCH /trainer/trainees/{id}`
- `POST /trainer/trainees/{id}/pause`
- `POST /trainer/trainees/{id}/resume`
- `PATCH /trainer/trainees/{id}/subscription`

Canonical Trainer baseline endpoints currently available:
- `GET /trainer/trainees/{id}/starting-baseline`
- `GET /trainer/trainees/{id}/starting-baseline/photos/{photoId}/read-access`
- `PATCH /trainer/trainees/{id}/baseline-requirement`

Important backend delta: Trainer-entered baseline upload/completion does NOT exist in the current production backend. Do not create fake local persistence. It requires backend work. Check-in comparison must preserve two independent references: Previous Reviewed Check-in and Client Start / Starting Baseline.

## Known product deltas not to fake

- Trainer-entered Starting Baseline write flow requires backend endpoints.
- Notification `Mark All as Read` requires a race-safe backend read-through/snapshot endpoint.
- Full Cardio edit support is a planned expansion if not present in backend.
- Dynamic Forms is a new product module and supersedes the older rule that V1 Daily Tracking is not an arbitrary form builder; update backend product rules when implementing it.

## Test status

The first PR CI failed during analyzer before tests. This checkpoint must be updated with a green CI run before declaring Phases 0–2 complete.

## Next exact step

1. Get Phase 0–2 hardening CI green.
2. Only after green, implement Phase 3 Workout + Exercise Library from canonical `workoutApi.ts` and `exerciseApi.ts`.
3. Add Phase 3 unit/widget/integration tests and rerun full Phase 1–3 regression.
4. Update this checkpoint with the exact Phase 3 files, routes, endpoints and final CI result.
