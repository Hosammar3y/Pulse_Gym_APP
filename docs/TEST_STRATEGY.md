# Pulse Coach Mobile — Test Strategy and Phase Gate

## Non-negotiable delivery rule

No phase may be considered complete, and no next phase may start, until the current phase has all of the following:

1. Product behavior implemented against the canonical backend contracts.
2. `flutter analyze` passes with no errors.
3. Unit/domain/data tests pass.
4. Widget/presentation tests pass where the phase has UI.
5. Integration tests for the phase's primary user journey pass.
6. Regression tests for all previously completed phases pass.
7. The AI agent checkpoint and phase document are updated with exact files, routes, API contracts, known backend deltas, CI run and next step.
8. GitHub CI is green.

If a historical phase lacks tests or documentation, STOP and retrofit it before starting later product work.

## Test layers

- Unit: mapping, domain rules, repository/use-case behavior and deterministic utilities.
- Widget: loading/success/empty/error states, form behavior, navigation triggers, lifecycle controls.
- Integration: multiple feature components wired through Riverpod overrides/fake repositories; verify the user journey without calling production.
- Contract alignment: mobile endpoint paths and payloads are compared with `gym-coaching-platform` source before implementation.

## CI commands

```bash
flutter pub get
flutter analyze
flutter test test
flutter test integration_test
```

The PR must not be merged while any command is red.
