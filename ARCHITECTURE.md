# Pulse Coach Mobile Architecture

## Rules

1. `main.dart` only bootstraps dependencies and starts `PulseCoachApp`.
2. App-level concerns live under `lib/app/`.
3. Cross-cutting infrastructure lives under `lib/core/`.
4. Reusable visual primitives live under `lib/shared/`.
5. Product capabilities live under `lib/features/<feature>/`.
6. Non-trivial features are split into `data`, `domain`, and `presentation`.
7. Presentation code never performs HTTP directly.
8. Domain code never imports Flutter UI.
9. Realtime transport is centralized in `core/realtime` and notifications own event interpretation.
10. Ticket message payloads are always refetched from the canonical Ticket REST API; SSE only signals new activity.

## Dependency direction

`presentation -> controller -> use case -> repository interface -> repository implementation -> remote data source -> ApiClient`

## Realtime notification flow

`SSE -> RealtimeClient -> NotificationsRepository -> notification state -> bell / center / toast / Inbox unread counters`
