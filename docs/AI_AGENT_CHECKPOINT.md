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
- Last verified green functional CI run: `34141533469`
- CI result for that run: Analyze ✅ / unit+widget ✅ / Linux integration ✅

## Phase 0 — Architecture foundation

Scope: bootstrap, app/router/theme, network, secure storage, realtime/SSE boundary, feature-first structure, shared shell, CI.

Status: implemented and verified by CI as part of the Phase 0–2 hardening gate.

Important CI environment rule: Linux integration tests on GitHub Actions must use a headless X display (`xvfb-run -a`) after generating the temporary Linux host. See `docs/TEST_STRATEGY.md`.

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

Status: implemented and regression-tested in CI.

Integration-test note: `TodayPage` uses a lazy `ListView`. Lower sections such as `Recent Clients` must be reached with `scrollUntilVisible` in integration tests instead of assuming they are built in the initial viewport.

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

Status: implemented and regression-tested in CI together with Phase 1.

## Current automated test inventory

Unit/domain/data tests currently cover:
- Auth login/session mapping.
- Temporary-password auth result behavior.
- Today snapshot mapping/counts.
- Client model and create payload mapping.
- Starting Baseline FRONT/SIDE/BACK mapping.
- Notification grouping/unread-count behavior.

Integration coverage currently includes:
- Phase 1 Today authoritative workbench snapshot.
- Phase 2 Client directory server-owned data rendering.

Last verified functional gate: GitHub Actions run `34141533469`, all required steps green.

## CI failure history that future agents must understand

### Failure 1 — Linux app could not start

Symptom:

`Error waiting for a debug connection: The log reader stopped unexpectedly, or never started.`

Root cause: Flutter Linux integration app was being launched on a headless GitHub Actions runner without a virtual display.

Fix: install/use `xvfb` and run:

`xvfb-run -a flutter test integration_test -d linux`

### Failure 2 — Today integration test could not find `Recent Clients`

The application launched successfully, but the test returned zero matches for `Recent Clients`.

Root cause: the section was below the initial viewport of a lazy `ListView`, so Flutter correctly had not built it yet. This was a test defect, not a product UI defect.

Fix: `scrollUntilVisible` to the section before asserting it. Do not convert production lazy lists into eager columns just to satisfy tests.

## Known product deltas not to fake

- Trainer-entered Starting Baseline write flow requires backend endpoints.
- Notification `Mark All as Read` requires a race-safe backend read-through/snapshot endpoint.
- Full Cardio edit support is a planned expansion if not present in backend.
- Dynamic Forms is a new product module and supersedes the older rule that V1 Daily Tracking is not an arbitrary form builder; update backend product rules when implementing it.

## Phase 3 status

Phase 3 Workout + Exercise Library is NOT present in PR #1 at this checkpoint. Do not describe it as implemented merely because it has been planned/reviewed.

Before beginning Phase 4, Phase 3 must be implemented completely and pass its own gate:

1. Workout + Exercise Library implementation against canonical backend contracts.
2. Phase 3 unit/domain/data tests.
3. Phase 3 widget tests for key presentation states/actions.
4. Phase 3 integration journey.
5. Regression integration coverage for Phases 1–3.
6. `flutter analyze` green.
7. GitHub CI green.
8. Update this checkpoint with exact Phase 3 files/routes/endpoints/test inventory/run ID.

## Next exact step

1. Treat Phase 0–2 as the current green baseline.
2. Implement Phase 3 Workout + Exercise Library only.
3. Add Phase 3 unit/widget/integration coverage plus Phases 1–3 regression.
4. Get CI fully green.
5. Update this checkpoint.
6. Only then may Phase 4 start.
