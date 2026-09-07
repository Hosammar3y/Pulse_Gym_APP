# Phase 2 — Clients, Client Profile, Starting Baseline

## Source contracts reviewed

Current source repository contracts used by this mobile phase:

- `GET /api/trainer/trainees`
- `POST /api/trainer/trainees`
- `GET /api/trainer/trainees/{id}`
- `POST /api/trainer/trainees/{id}/pause`
- `POST /api/trainer/trainees/{id}/resume`
- `GET /api/trainer/trainees/{id}/starting-baseline`
- `GET /api/trainer/trainees/{id}/starting-baseline/photos/{photoId}/read-access`

Current production Baseline trainer write scope remains limited to updating REQUIRED/OPTIONAL. Baseline photo upload and completion are trainee endpoints today.

## Mobile Phase 2 behavior

- Client list with server-side search/status filters.
- Add Client with personal/coaching/subscription/baseline requirement fields.
- Client Profile as the central coaching context.
- Pause/resume actions use canonical server endpoints.
- Starting Baseline screen reads canonical trainer baseline data.
- FRONT/SIDE/BACK remain the required photo angles.
- Trainer-entered baseline is visible as a planned capability but disabled until backend write endpoints are delivered; the app must not fake persisted state.
- Check-in comparison references remain distinct: Previous Reviewed Check-in and Client Start.

## Next backend delta for Trainer-entered baseline

When approved, add server-authoritative Trainer endpoints for owned clients to prepare/upload/confirm FRONT/SIDE/BACK photos and complete a positive starting weight. Preserve completed-baseline immutability and permanent baseline photo retention.
