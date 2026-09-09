# Pulse Coach Mobile — Enhancement Handoff

## Purpose

This document preserves Trainer-mobile enhancement work while GitHub Actions usage/credits prevent runners from executing and provides an exact path to validate the same branch from another GitHub account/repository.

Never treat a workflow run with no allocated runner/steps as code validation.

## Source of truth

Repository:

`Hosammar3y/Pulse_Gym_APP`

Base branch:

`main`

Base commit:

`84d1274eccf4c8341391e0ae95cc5b787ddec3ee`

Working branch:

`feat/mobile-enhancements-bundle`

Safety snapshot:

`feat/mobile-enhancements-bundle-safety-copy`

## Implemented now — Block 1

The branch currently contains the temporary-password forced-change foundation and remembered-login-email behavior.

Required flow:

`Temporary password login -> forced Change Password -> complete backend challenge -> return to Login -> email prefilled -> password blank -> login again using the new password`

Backend endpoints:

- `POST /api/auth/login`
- `POST /api/auth/complete-temporary-password`

Temporary-password login response fields consumed by mobile:

- `passwordChangeRequired`
- `passwordChangeToken`

Security rules:

- challenge token is transient state only;
- do not persist current/temporary/new passwords;
- do not persist `passwordChangeToken`;
- only the normalized login email may be stored in SharedPreferences;
- existing access/refresh tokens remain in the established secure-storage mechanism;
- a temporary-password challenge must block navigation into the normal Trainer shell until completed.

## Block 2 — exact Trainer Starting Baseline contract

Do not guess response field names.

Base:

`/api/trainer/trainees/{traineeId}/starting-baseline`

Endpoints:

- `GET /api/trainer/trainees/{traineeId}/starting-baseline`
- `POST /api/trainer/trainees/{traineeId}/starting-baseline/photos/upload-intents`
- `POST /api/trainer/trainees/{traineeId}/starting-baseline/photos/{photoId}/confirm`
- `DELETE /api/trainer/trainees/{traineeId}/starting-baseline/photos/{photoId}`
- `GET /api/trainer/trainees/{traineeId}/starting-baseline/photos/{photoId}/read-access`
- `POST /api/trainer/trainees/{traineeId}/starting-baseline/complete`

Upload-intent request:

```json
{
  "angle": "FRONT",
  "contentType": "image/jpeg"
}
```

Exact response:

```json
{
  "photoId": "11111111-2222-3333-4444-555555555555",
  "angle": "FRONT",
  "intent": {
    "url": "https://<signed-object-storage-upload-url>",
    "expiresAt": "2026-09-10T00:20:00Z",
    "requiredHeaders": {}
  }
}
```

`requiredHeaders` is dynamic and may be empty. Apply every returned entry to the direct binary `PUT`. Do not hardcode provider-specific headers.

Correct sequence:

1. POST upload-intent.
2. Read `photoId`, `intent.url`, and `intent.requiredHeaders`.
3. PUT raw image bytes directly to `intent.url` with all returned headers.
4. Only after successful PUT, POST confirm using `photoId`.
5. Refetch Starting Baseline.
6. Use read-access endpoint for temporary secure preview URL.

Confirm response fields:

- `id`
- `angle`
- `uploadConfirmed`
- `contentType`
- `sizeBytes`
- `uploadConfirmedAt`

Complete request:

```json
{
  "startingWeightKg": 72.5
}
```

Completion requires confirmed FRONT + SIDE + BACK, positive weight, owning Trainer, ACTIVE Trainee, and mutable baseline.

Relevant backend business codes:

- `TRAINEE_COACHING_ACCESS_BLOCKED`
- `BASELINE_ALREADY_COMPLETED`
- `BASELINE_PHOTOS_INCOMPLETE`
- `BASELINE_WEIGHT_INVALID`
- `BASELINE_PHOTO_UPLOAD_INVALID`
- `BASELINE_PHOTO_ANGLE_ALREADY_CONFIRMED`
- `BASELINE_PHOTO_NOT_FOUND`

## Remaining mobile blocks

### Block 2

Implement Trainer-created/continued Starting Baseline for an existing ACTIVE client using the exact contract above.

### Block 3

Reliable Add Client orchestration:

`Create Trainee -> retain traineeId -> set temporary password if supplied -> assign questionnaire if selected -> success`

Important: retry after creation must not create another Trainee.

Endpoints:

- `POST /api/trainer/trainees`
- `POST /api/trainer/trainees/{id}/temporary-password`
- `GET /api/trainer/baseline-form-templates`
- `POST /api/trainer/baseline-form-templates`
- `PUT /api/trainer/trainees/{id}/baseline-form`

### Block 4

Customer Profile account actions:

- manual pause: `POST /api/trainer/trainees/{id}/pause` with `pauseUntil: null`;
- scheduled pause: same endpoint with future `pauseUntil`;
- resume: `POST /api/trainer/trainees/{id}/resume`;
- remove PENDING Questionnaire: `PUT /api/trainer/trainees/{id}/baseline-form` with `templateId: null`;
- edit subscription period: `PATCH /api/trainer/trainees/{id}/subscription`;
- set/reset temporary password: `POST /api/trainer/trainees/{id}/temporary-password`.

The source future-enhancement branch additionally introduces:

`POST /api/trainer/trainees/{id}/subscription/expire`

Do not depend on Expire Now from mobile until the source backend enhancement is validated, merged, and deployed to the environment used by mobile.

### Block 5

Trainer program/progress readiness:

- Trainer Cardio edit;
- Trainer Diet edit;
- scalable Workout accordion;
- Progress selectors;
- Daily Tracking paged modes once source backend enhancement is available;
- pageable Cardio evidence once source backend enhancement is available;
- responsive regression.

## New source-side enhancements mobile will consume later

Source repository:

`Hosammar3y/gym-coaching-platform`

Branch:

`feat/future-enhancements-bundle`

That unverified source branch contains:

1. Trainer-created Starting Baseline for existing ACTIVE Trainee.
2. Coach feedback note after REVIEWED Check-in, readable by Trainee.
3. Daily Tracking server-side `LATEST / ALL / SPECIFIC_DATE / DATE_RANGE` paging.
4. Explicit `Expire Subscription Now`.
5. Pageable Cardio evidence.
6. Trainer Web remembered login email after temporary-password completion.
7. Starting Baseline responsive zoomable photo preview polish.

Treat those as future/development contracts until source verification, merge and deployment happen.

## Required tests when tooling is available

Run:

```bash
flutter pub get
flutter analyze
flutter test
```

Block 1 focused validation must cover:

- normal login creates a session;
- temporary-password login does not create a normal session;
- challenge token remains transient;
- forced-change route is gated;
- successful change returns to Login;
- previous email is prefilled;
- password is blank;
- only email is persisted.

Block 2 must cover exact upload-intent parsing, all dynamic required headers, direct PUT failure preventing confirm, successful PUT followed by confirm, secure preview, remove, completion gating, completed read-only behavior and non-ACTIVE blocking.

Each later block must add focused tests before full `flutter test`.

## Validate from another GitHub account/repository

From a local clone:

```bash
git fetch origin
git checkout feat/mobile-enhancements-bundle
git pull --ff-only origin feat/mobile-enhancements-bundle

git remote add validation <NEW_ACCOUNT_MOBILE_REPOSITORY_URL>
git push validation feat/mobile-enhancements-bundle:mobile-enhancement-validation
```

Then on the alternate account:

1. Open a validation PR.
2. Run the Flutter workflow using that account's Actions quota.
3. Record the exact tested SHA.
4. Do not merge merely to obtain CI evidence.
5. Bring fixes back to the original working branch.

Patch fallback:

```bash
git format-patch 84d1274eccf4c8341391e0ae95cc5b787ddec3ee..feat/mobile-enhancements-bundle --stdout > pulse-mobile-enhancements.patch
```

Bundle fallback:

```bash
git bundle create pulse-mobile-enhancements.bundle feat/mobile-enhancements-bundle
```

## Current status

- Block 1 code exists on the working branch.
- Blocks 2–5 are not complete unless later commits explicitly add them.
- CI is not considered executed when no runner is allocated.
- No merge or deployment is authorized by this handoff.
