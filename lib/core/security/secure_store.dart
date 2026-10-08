import 'dart:convert';
import 'dart:math';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Thin wrapper over the platform keystore (Android Keystore-backed
/// encryption). Holds the Supabase session and the per-user database keys.
/// Raw passwords are never stored anywhere.
class SecureStore {
  SecureStore([FlutterSecureStorage? storage]) : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  Future<String?> read(String key) => _storage.read(key: key);
  Future<void> write(String key, String value) => _storage.write(key: key, value: value);
  Future<void> delete(String key) => _storage.delete(key: key);

  /// The encryption key of a user's local database, created on first use.
  Future<String> databaseKey(String userId) async {
    final name = 'db_key_$userId';
    final existing = await read(name);
    if (existing != null) return existing;
    final random = Random.secure();
    final key = base64Url.encode(List<int>.generate(32, (_) => random.nextInt(256)));
    await write(name, key);
    return key;
  }

  Future<void> deleteDatabaseKey(String userId) => delete('db_key_$userId');
}

/// Supabase session persistence in the keystore instead of plain shared
/// preferences, so refresh tokens are not readable from app storage.
class SecureSessionStorage extends LocalStorage {
  SecureSessionStorage(this._store);

  final SecureStore _store;
  static const _key = 'supabase_session';

  @override
  Future<void> initialize() async {}

  @override
  Future<bool> hasAccessToken() async => (await _store.read(_key)) != null;

  @override
  Future<String?> accessToken() => _store.read(_key);

  @override
  Future<void> persistSession(String persistSessionString) => _store.write(_key, persistSessionString);

  @override
  Future<void> removePersistedSession() => _store.delete(_key);
}

/// PKCE verifier storage for password-reset / magic-link flows.
class SecurePkceStorage extends GotrueAsyncStorage {
  SecurePkceStorage(this._store);

  final SecureStore _store;

  @override
  Future<String?> getItem({required String key}) => _store.read('pkce_$key');

  @override
  Future<void> removeItem({required String key}) => _store.delete('pkce_$key');

  @override
  Future<void> setItem({required String key, required String value}) => _store.write('pkce_$key', value);
}
