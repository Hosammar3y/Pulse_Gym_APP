# Pulse Coach Mobile

Trainer-first Flutter client for the Pulse Coach platform.

## Architecture

This repository follows feature-first Clean Architecture with Riverpod, go_router and Dio.

Dependency direction:

`presentation -> domain -> data contracts -> infrastructure`

Feature UI does not call HTTP directly. `main.dart` only bootstraps the app.

## Current implementation

Phase 0 foundation:

- tiny `main.dart`
- centralized app bootstrap
- centralized Material 3 theme
- centralized go_router navigation shell
- shared API client with auth interceptor boundary
- secure token storage abstraction
- centralized SSE realtime client
- feature-first Auth foundation
- feature-first Notifications foundation
- grouped ticket-reply notification algorithm matching the existing web behavior
- top-level Trainer navigation: Today / Clients / Programs / Inbox / More

Phase 2 implementation:

- Trainer client directory
- client search/status filters
- client profile overview
- add-client workflow
- client lifecycle actions (pause/resume)
- baseline summary and read flow
- baseline comparison entry points preserved for Previous Check-in and Client Start
- trainer-entered baseline explicitly modeled as a backend delta until server endpoints exist

## Backend source of truth

Mobile feature behavior must be verified against:

- `Hosammar3y/gym-coaching-platform`
- `Hosammar3y/gym-coaching-platform-azure`, branch `deployment/azure-vm-production`

Do not invent backend contracts if an existing endpoint already exists.

## Important backend deltas

- `POST /api/notifications/read-all` is a new product requirement and does not exist in the current backend baseline. Implement it server-side with a snapshot/cutoff contract before wiring the mobile action.
- Trainer-entered starting baseline write endpoints do not exist in the current production backend baseline. Current trainer baseline API is read-only except for requirement updates; the mobile code must not fake this capability.

## Local setup

The environment used to scaffold this repository did not include the Flutter SDK, so platform folders and analyzer verification were not generated here.

With Flutter installed:

```bash
flutter create --platforms=android,ios .
flutter pub get
flutter analyze
flutter test
```

Do not overwrite `lib/` when generating platform folders.
