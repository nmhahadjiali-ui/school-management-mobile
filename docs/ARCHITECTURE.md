# Mobile architecture (Phase 6)

## One backend

The app is another client of the same platform. It talks only to the
Supabase project the web app uses:

| Need | How (same as the web) |
| --- | --- |
| Sign in, session, password reset | Supabase Auth (reset completes on the web app) |
| Who am I, which school, which features | `get_my_context()` — the school always comes from the user's server profile; the app never lets anyone pick a school |
| Reading data | PostgREST queries under the user's **RLS** (the same policies as the web) |
| Offline attendance | `sync_attendance()`, which saves through the web's own `save_attendance()` |
| Notifications read state | `notifications.read_at` (same column the web uses) |
| Devices | `register_device()` / own `user_devices` rows (Phase 4) |

No mobile-only backend, no weaker mobile policies, no duplicated business
rules. Payments, refunds, grade entry, announcements publishing and school
setup stay on the web, where they already live.

## Code layout

```
lib/
  core/
    config/       AppConfig (public, build-time values only)
    errors/       AppError: friendly messages, offline detection, no leaked details
    network/      ConnectivityService: real reachability (probe), not just "Wi-Fi on"
    security/     SecureStore (Android Keystore): session + per-user database keys
    session/      UserContext (from get_my_context) · SessionController (open/close a user)
    storage/      LocalDatabase (drift, encrypted, one file per user)
    sync/         RemoteApi (interface + Supabase implementation) · SyncEngine
    push/         PushTokenSource (FCM plugs in here)
    routing/      go_router + deep links
  features/       attendance · academics · communication · finance · dashboard · auth
  shared/         widgets (sync banner, empty/error views, formatting)
```

## Local database — why drift on SQLite (SQLite3 Multiple Ciphers)

* Real relational storage: typed tables, joins (rosters × marks), indexes,
  transactions (a sheet is saved atomically with its queue entry), reactive
  queries (screens update the moment sync writes), migrations.
* Works on Android and iOS (and desktop for tests) with the same code.
* **Encrypted at rest**: `package:sqlite3` bundles SQLite3 Multiple Ciphers
  (MIT); every user's database is keyed with 32 random bytes stored in the
  Android Keystore via flutter_secure_storage.
* Key-value storage is used only for the session and keys (secure storage).

## What is cached (only what the role needs)

| Role | Cached |
| --- | --- |
| Everyone | context (profile, school, features, current year), notifications (60 days), active announcements |
| Teacher | own sections (RLS), their enrolled students, own schedule, attendance sheets of the last 14 days, own assignments, grades they entered |
| Student | own enrollment/section, schedule, published assignments, published grades, own attendance (60 days), balances and payments (if the school enabled them) |
| Parent | the same for verified children only |
| Finance staff | school totals snapshot; student lookup is **online only** |
| School admin | totals (if finance access), announcements, notifications; administration stays on the web |

Never the whole school. Lists are replaced per sync (so records the user lost
access to disappear); notifications are upserted by id and pruned after 60 days.
Cache expiry affects only the device — server history is untouched.

## Offline attendance

1. Teacher opens a class (roster from the cache), marks P/A/L/E, saves.
2. In ONE local transaction: the marks are stored as **local edits next to
   the server copy** (`server_status/updated_at` vs `local_status`), the
   server version each edit was based on is captured (`base_updated_at`), and
   a sync-queue operation is created (or updated, if it was never sent).
3. The engine pushes when connected: `sync_attendance(op_id, section, date, records)`.
4. The server (SECURITY INVOKER — runs as the teacher):
   * returns the stored result if `op_id` was already processed (idempotent);
   * refuses non-teachers; RLS + `save_attendance` enforce teacher assignment,
     school, section, enrollment on that date, locks and the edit window;
   * per student: if the server record changed after `base_updated_at` and
     differs → **conflict** (not written); otherwise saved;
   * records the result under `op_id` and returns current server rows.
5. The app marks synced rows ✓, flags conflicts ⚠ for review, and shows
   rejections (e.g. "Attendance for this day is locked") in the sync center.

## Sync engine

`SyncEngine.syncNow()` — single-flight, one place for all synchronization:
pull (scoped refresh) → push (queue, oldest first) → status. Triggers: sign-in,
app resume, connectivity regained, every 5 minutes while open, pull-to-refresh
and "Sync now" (throttled to once per 15 s). Background execution on Android
is limited by the OS; nothing depends on it (WorkManager can call the same
`syncNow()` later).

Queue entry: `id (operation id) · entity_type · entity_id · operation ·
payload · created_at · attempt_count · last_attempt_at · status
(pending|processing|synced|failed|conflict) · error_message`.

* Network/temporary errors → stays `pending`, attempt counted, pushing stops
  until the next run (order preserved); after 8 attempts → `failed`.
* Server rejection → `failed` with the server's reason (retry or discard).
* A never-sent operation is rebuilt from current edits at send time; a sent
  operation is replayed byte-for-byte (so the server's de-duplication holds).

## Duplicate prevention

* Device-generated operation ids + `client_operations` on the server (one
  row per id per user, advisory lock against concurrent replays). Ids of
  another user are refused.
* Pulls upsert by server id (no duplicate notifications); attendance rows
  are keyed `(section, date, student)` locally and `(session, student)` on
  the server.
* Marking a notification read is queued and only sets `read_at` where empty.

## Conflicts

Attendance uses explicit conflict handling (no silent last-write-wins):
the teacher sees both values and chooses **Use server version** (local edit
discarded) or **Keep mine** (resent against the server's current version —
a deliberate overwrite, audited like any edit). Grades are view-only on
mobile in this phase; financial data is view-only.

## Isolation between users

* One database file per user id, each with its own key in the keystore.
* Sign-out: unregister the push token, wipe and delete the file (+ WAL), delete
  the key, clear the stored session. Unsynced changes trigger a warning first.
* A different account signing in closes the previous one completely first.
* Android backup and device transfer are disabled for app data.

## Push notifications

`PushTokenSource` abstracts the provider. With Firebase connected:
add `google-services.json`, `firebase_core` + `firebase_messaging`, implement
`currentToken()` / `tokenRefreshes` / `openedNotifications` with
FirebaseMessaging, and override `pushSourceProvider`. The app already
registers the token after sign-in (`register_device`: multiple devices per
user, refresh updates the row and last-seen), removes it on sign-out, and
routes taps by the standard payload `{entity_type, entity_id}`. The server
side needs an FCM sender in the delivery worker (web repo,
`src/server/notifications/providers.ts`).

## iOS later

All business logic (sync, storage, API, routing) is platform-independent
Dart; the only platform-specific pieces are configuration (Android manifest,
network security) and the future push provider. An `ios/` folder is
generated; adding iOS = signing, APNs/FCM setup and testing.
