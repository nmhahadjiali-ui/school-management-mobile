# School Management — Android app (Flutter)

The mobile client of the School Management platform. It is **not a second
system**: it uses the same Supabase project, the same database functions and
the same Row Level Security as the web app, and adds an offline-first local
layer.

```
Next.js web ──┐
              ├──► Supabase (Auth · PostgreSQL · RLS · Storage)
Flutter app ──┘          ▲
     │                   │  sync engine (pull ▸ push ▸ resolve)
     ▼                   │
 encrypted local database (per user)  ──►  UI
```

Architecture, offline and security details: [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md).

## Requirements

* Flutter 3.47+ (stable), Android SDK 36, Java 17–21.
* The web project's Supabase backend (local or hosted) with migrations up to
  `20261014000001_mobile_sync.sql`.

## Configuration

Only **public** client values go in the app (anything compiled into an app
can be extracted). Copy `config/example.json`:

| File | Use |
| --- | --- |
| `config/local.json` | local Supabase from the web repo (`npm run db:start`); the emulator reaches your PC as `10.0.2.2` (plain HTTP allowed in debug builds only) |
| `config/hosted.json` | the hosted Supabase project |

Never add service-role keys, payment, SMS or email secrets.

## Run

```bash
flutter pub get
dart run build_runner build      # regenerates the drift database code
flutter run --dart-define-from-file=config/local.json      # emulator + local backend
flutter run --dart-define-from-file=config/hosted.json     # real backend
```

Demo accounts (after `npm run seed -- --demo` in the web repo): `teacher@north.example`,
`student@north.example`, `parent@north.example`, `finance@north.example`, … password `Demo-pass-123`.

## Build

```bash
flutter build apk --release --dart-define-from-file=config/hosted.json
```

Before Google Play: change `applicationId` in `android/app/build.gradle.kts`
(currently `com.schoolmanagement.school_mobile`), create an upload keystore and
signing config, and use Play's internal testing track first. Nothing is
published automatically.

## Tests

```bash
flutter test
```

| File | Covers |
| --- | --- |
| `test/sync_engine_test.dart` | offline attendance queued and retried, idempotent replay, conflict detection and both resolutions, server rejections (retry/discard), queue immutability once sent, edits while in flight, roster-only writes, notification de-duplication and offline read state |
| `test/security_test.dart` | database encrypted at rest, wrong key refused, per-user isolation, wipe on sign-out, friendly error mapping (no leaked details), deep link mapping, server-provided school context and feature flags |

Server-side rules (authorization, tenant isolation, idempotency, conflicts)
are tested in the web repo: `tests/mobile-sync.test.mjs`, plus every RLS
suite, because the app uses exactly those APIs.

### Android checklist (manual)

Small phone + tablet emulator, Android 9 and 15: sign in → kill the app → reopen
(session restored offline) · airplane mode → take attendance → kill the app →
reopen (still pending) → network on (syncs, ✓ Synced) · change the same record on
the web meanwhile (conflict shown, both resolutions) · sign out with pending
changes (warning) → sign in as another user (no previous data) · slow network
(Android emulator network speed "EDGE").
