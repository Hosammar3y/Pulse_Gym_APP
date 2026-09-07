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

Local/unit verification:

```bash
flutter pub get
flutter analyze
flutter test test
```

Linux GitHub Actions integration verification is headless and must run with a virtual X display:

```bash
sudo apt-get update
sudo apt-get install -y clang cmake ninja-build pkg-config libgtk-3-dev liblzma-dev libsecret-1-dev xvfb
flutter create --platforms=linux --project-name pulse_coach_mobile .
xvfb-run -a flutter test integration_test -d linux
```

Do not run Linux Flutter integration tests directly on GitHub Actions without `xvfb-run`; the desktop app needs a display/debug connection even though the test runner is headless.

## Integration-test viewport rule

Production pages may use lazy scrolling containers such as `ListView`. Content below the initial test viewport might not exist in the widget tree until scrolled into view. Integration tests must therefore test the real user journey rather than assume all list children are eagerly built.

Correct pattern:

```dart
await tester.scrollUntilVisible(
  find.text('Target section'),
  300,
  scrollable: find.byType(Scrollable).first,
);
await tester.pumpAndSettle();
expect(find.text('Target section'), findsOneWidget);
```

Do not weaken the production UI just to make an integration test pass. Fix the test when the failure is caused by legitimate lazy rendering.

## Regression policy

After Phase N is implemented:

```text
Phase N unit/widget tests
        ↓
Phase N integration journey
        ↓
Phases 1..N regression suite
        ↓
flutter analyze
        ↓
GitHub CI green
        ↓
checkpoint update
        ↓
Phase N+1 may begin
```

The PR must not be merged while any required gate is red.

## CI incident record — 2026-09-07

Two CI-only integration issues were discovered during the Phase 0–2 hardening gate:

1. Linux desktop integration tests initially could not establish a Flutter debug connection on the headless GitHub runner. Resolution: install/use Xvfb and run integration tests through `xvfb-run -a`.
2. After the app launched correctly, the Today integration test expected `Recent Clients` before the lazy `ListView` had built that lower section. Resolution: scroll the actual Today list until `Recent Clients` is visible, then assert the section/client data.

Verification run `34141533469` completed green after both corrections: Analyze ✅, unit/widget tests ✅, Linux integration tests ✅.
