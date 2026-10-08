import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../config/app_config.dart';
import '../errors/app_error.dart';
import '../network/connectivity_service.dart';
import '../push/push_service.dart';
import '../security/secure_store.dart';
import '../storage/local_database.dart';
import '../sync/remote_api.dart';
import '../sync/sync_engine.dart';
import 'user_context.dart';

const appVersion = '1.0.0';

// --- Infrastructure (overridden in main / tests) -----------------------------
final appConfigProvider = Provider<AppConfig>((_) => throw UnimplementedError('override in main'));
final secureStoreProvider = Provider<SecureStore>((_) => SecureStore());
final supabaseProvider = Provider<SupabaseClient>((_) => Supabase.instance.client);
final remoteApiProvider = Provider<RemoteApi>((ref) => SupabaseRemoteApi(ref.watch(supabaseProvider)));
final pushSourceProvider = Provider<PushTokenSource>((_) => NoPushTokenSource());
final connectivityProvider = Provider<ConnectivityService>((ref) {
  final config = ref.watch(appConfigProvider);
  final service = ConnectivityService(probeUrl: Uri.parse('${config.supabaseUrl}/auth/v1/health'));
  ref.onDispose(service.dispose);
  return service;
});

/// Everything that belongs to ONE signed-in user. Nothing in here outlives
/// sign-out, and a different user always gets a different instance.
class UserSession {
  UserSession({required this.userId, required this.db, required this.sync});

  final String userId;
  final LocalDatabase db;
  final SyncEngine sync;
}

final sessionProvider = AsyncNotifierProvider<SessionController, UserSession?>(SessionController.new);

class SessionController extends AsyncNotifier<UserSession?> {
  StreamSubscription<AuthState>? _authSub;
  final List<StreamSubscription<dynamic>> _subs = [];
  Timer? _periodic;
  /// The user whose data is open (or opening) — guards against opening twice
  /// when Supabase re-announces the restored session at start-up.
  String? _activeUserId;

  SupabaseClient get _client => ref.read(supabaseProvider);

  @override
  Future<UserSession?> build() async {
    ref.onDispose(() {
      _authSub?.cancel();
      _closeHooks();
    });
    // Session restored from secure storage on app start (works offline).
    final user = _client.auth.currentUser;
    _activeUserId = user?.id;
    _authSub = _client.auth.onAuthStateChange.listen((event) async {
      final next = event.session?.user;
      if (event.event == AuthChangeEvent.signedOut || next == null) {
        if (_activeUserId == null) return;
        _activeUserId = null;
        final current = state.value;
        state = const AsyncData(null); // close the signed-in screens first
        if (current != null) await _teardown(current, deleteData: true);
      } else if (next.id != _activeUserId) {
        // A different account: the previous one (if any) is fully closed first.
        final previous = state.value;
        _activeUserId = next.id;
        state = const AsyncLoading(); // close the previous user's screens first
        if (previous != null) await _teardown(previous, deleteData: true);
        state = await AsyncValue.guard(() => _open(next.id));
      }
    });
    return user == null ? null : _open(user.id);
  }

  Future<UserSession> _open(String userId) async {
    final store = ref.read(secureStoreProvider);
    final key = await store.databaseKey(userId);
    LocalDatabase db;
    try {
      db = await LocalDatabase.openForUser(userId, key);
      await db.customSelect('SELECT 1').get(); // forces the key check
    } catch (_) {
      // Unreadable cache (e.g. key lost after a reinstall): it is only a
      // cache — start clean. Pending changes in it could not be trusted anyway.
      final file = await LocalDatabase.fileForUser(userId);
      if (await file.exists()) await file.delete();
      db = await LocalDatabase.openForUser(userId, key);
    }
    final connectivity = ref.read(connectivityProvider);
    late final SyncEngine sync;
    sync = SyncEngine(
      db: db,
      remote: ref.read(remoteApiProvider),
      connectivity: connectivity,
      contextLoader: () async {
        final raw = await sync.getMeta('context');
        return raw == null ? null : UserContext.fromJson(jsonDecode(raw) as Map<String, dynamic>);
      },
    );
    final session = UserSession(userId: userId, db: db, sync: sync);
    _installHooks(session, connectivity);
    unawaited(sync.syncNow());
    unawaited(_registerDevice(session));
    return session;
  }

  void _installHooks(UserSession session, ConnectivityService connectivity) {
    _closeHooks();
    unawaited(connectivity.start());
    _subs.add(connectivity.onlineChanges.where((online) => online).listen((_) => session.sync.syncNow()));
    final push = ref.read(pushSourceProvider);
    _subs.add(push.tokenRefreshes.listen((_) => _registerDevice(session)));
    // While the app is open: a light periodic sync (background execution on
    // Android is limited by the OS; foreground sync never depends on it).
    _periodic = Timer.periodic(const Duration(minutes: 5), (_) => session.sync.syncNow());
  }

  void _closeHooks() {
    for (final s in _subs) {
      s.cancel();
    }
    _subs.clear();
    _periodic?.cancel();
  }

  /// Registers this device for push (multiple devices per user are fine;
  /// re-registering refreshes the token and "last seen").
  Future<void> _registerDevice(UserSession session) async {
    try {
      final token = await ref.read(pushSourceProvider).currentToken();
      if (token == null) return;
      await ref.read(remoteApiProvider).registerDevice(token: token, platform: Platform.isIOS ? 'ios' : 'android', appVersion: appVersion);
      await session.sync.setMeta('push_token', token);
    } catch (e) {
      if (kDebugMode) debugPrint('[push] device registration skipped: $e');
    }
  }

  Future<void> signIn(String email, String password) async {
    try {
      await _client.auth.signInWithPassword(email: email.trim(), password: password);
    } catch (e) {
      throw toAppError(e);
    }
  }

  Future<void> sendPasswordReset(String email) async {
    final web = ref.read(appConfigProvider).webUrl;
    try {
      // The reset itself happens on the web app (same accounts, same rules).
      await _client.auth.resetPasswordForEmail(email.trim(), redirectTo: web.isEmpty ? null : '$web/auth/confirm?next=/reset-password');
    } catch (e) {
      throw toAppError(e);
    }
  }

  /// Signs out and removes EVERYTHING this user left on the device: cached
  /// data, unsynced changes (the caller warns first), the database file and
  /// its key, the push registration and the stored session.
  ///
  /// Order matters: the signed-in screens are closed FIRST (state → null, so
  /// nothing is still reading the database), then the session ends, then the
  /// encrypted file and its key are deleted.
  Future<void> signOut() async {
    final current = state.value;
    _activeUserId = null;
    _closeHooks();
    String? token;
    if (current != null) {
      token = await current.sync.getMeta('push_token').timeout(const Duration(seconds: 3), onTimeout: () => null);
      current.sync.close();
    }
    state = const AsyncData(null);
    _log('signed-in screens closed');
    if (token != null) {
      try {
        await ref.read(remoteApiProvider).removeDevice(token).timeout(const Duration(seconds: 5));
      } catch (_) {/* offline: the server forgets stale tokens on delivery failure */}
    }
    try {
      await _client.auth.signOut().timeout(const Duration(seconds: 8));
    } catch (_) {
      await _client.auth.signOut(scope: SignOutScope.local);
    }
    _log('auth session cleared');
    if (current != null) await _teardown(current, deleteData: true);
  }

  Future<UserSession?> _teardown(UserSession session, {required bool deleteData}) async {
    _closeHooks();
    session.sync.close();
    try {
      await session.db.close().timeout(const Duration(seconds: 5));
    } catch (e) {
      _log('database close: $e');
    }
    if (deleteData) {
      // Deleting the encrypted file AND its key makes the data unrecoverable.
      final file = await LocalDatabase.fileForUser(session.userId);
      for (final f in [file, File('${file.path}-wal'), File('${file.path}-shm'), File('${file.path}-journal')]) {
        try {
          if (await f.exists()) await f.delete();
        } catch (e) {
          _log('delete ${f.path}: $e');
        }
      }
      await ref.read(secureStoreProvider).deleteDatabaseKey(session.userId);
      _log('local data and key deleted');
    }
    return null;
  }

  void _log(String message) {
    if (kDebugMode) debugPrint('[session] $message');
  }
}

// --- Per-user data access for screens ------------------------------------------------
final dbProvider = Provider<LocalDatabase>((ref) {
  final session = ref.watch(sessionProvider).value;
  if (session == null) throw StateError('Not signed in');
  return session.db;
});

final syncEngineProvider = Provider<SyncEngine>((ref) {
  final session = ref.watch(sessionProvider).value;
  if (session == null) throw StateError('Not signed in');
  return session.sync;
});

/// The cached context (available offline), refreshed by every sync.
final userContextProvider = StreamProvider<UserContext?>((ref) {
  final db = ref.watch(dbProvider);
  return (db.select(db.metaEntries)..where((m) => m.key.equals('context')))
      .watchSingleOrNull()
      .map((row) => row == null ? null : UserContext.fromJson(jsonDecode(row.value) as Map<String, dynamic>));
});

final syncStatusProvider = StreamProvider<SyncStatus>((ref) {
  final engine = ref.watch(syncEngineProvider);
  final controller = StreamController<SyncStatus>();
  void emit() => controller.add(engine.status.value);
  engine.status.addListener(emit);
  emit();
  ref.onDispose(() {
    engine.status.removeListener(emit);
    controller.close();
  });
  return controller.stream;
});

final onlineProvider = StreamProvider<bool>((ref) async* {
  final service = ref.watch(connectivityProvider);
  yield service.isOnline;
  yield* service.onlineChanges;
});

/// Live counts of the sync queue by status (pending / conflict / failed …),
/// so indicators update the moment a change is saved or resolved.
final queueCountsProvider = StreamProvider<Map<String, int>>((ref) {
  final db = ref.watch(dbProvider);
  return db
      .customSelect('SELECT status, count(*) AS n FROM sync_queue GROUP BY status', readsFrom: {db.syncQueue})
      .watch()
      .map((rows) => {for (final r in rows) r.read<String>('status'): r.read<int>('n')});
});
