# Pulse Coach Mobile — Enhancement Handoff

## Purpose

Preserve the Trainer-mobile enhancement plan and implementation state while GitHub Actions usage/credits prevent runners from executing. Never treat a run with no runner/steps as a code failure or as validation success.

## Planned blocks

1. Forced temporary-password completion using `/api/auth/complete-temporary-password`, then return to `/login` with the previously entered email prefilled from SharedPreferences; password remains blank and no password/token is persisted.
2. Trainer-created Starting Baseline for an existing ACTIVE client using the Trainer Starting Baseline endpoints added by source PR #55.
3. Reliable Add Client orchestration: create once, retain trainee ID, set temporary password, assign/create Questionnaire, and retry only failed post-create steps.
4. Customer Profile actions: manual/scheduled pause, resume, pending Questionnaire removal, supported subscription edit, temporary-password action.
5. Real Trainer Program/Progress pages replacing relevant deferred placeholders; scalable selectors/accordions and no fake local business state.
6. Later: Coach feedback note for reviewed Check-ins once the backend/web enhancement is available.

## Required verification when runners are available

```bash
flutter pub get
flutter analyze
flutter test
```

Run relevant integration tests when the environment supports them. Record exact counts/results. Do not claim Flutter verification when Flutter tooling was unavailable.

## Cross-account validation

Push the enhancement branch to an alternate repository/account and let that repository's Actions run the same Flutter CI. Preserve the exact source commit in the handoff status so results can be traced back.

## Security rules

- SharedPreferences may store the remembered login email only.
- Never store current/temporary/new passwords or `passwordChangeToken` in SharedPreferences.
- Access tokens remain in the existing secure-storage mechanism.

## Status

Implementation handoff initialized. Update this document with branch, SHA, changed files, tests actually executed, CI run IDs, and remaining gaps after each block.
