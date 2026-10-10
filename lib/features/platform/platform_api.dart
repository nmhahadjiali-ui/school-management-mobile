import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../core/errors/app_error.dart';
import '../../core/session/session.dart';
import '../../core/sync/remote_api.dart';

/// Platform administration (super admin), the same queries as the web's
/// /platform pages. Deliberately ONLINE-ONLY and never cached: data across
/// every school does not belong on a phone, and admin decisions need the
/// current state. Every call runs as the signed-in user, so RLS decides.
class PlatformApi {
  PlatformApi(this._db, this._webUrl);

  final SupabaseClient _db;
  final String _webUrl;

  Future<T> _run<T>(Future<T> Function() call) async {
    try {
      return await call();
    } catch (e) {
      throw toAppError(e);
    }
  }

  Future<Json> stats() => _run(() async {
        final r = await Future.wait([
          _db.from('schools').count(CountOption.exact),
          _db.from('schools').count(CountOption.exact).eq('status', 'active'),
          _db.from('schools').count(CountOption.exact).eq('status', 'inactive'),
          _db.from('profiles').count(CountOption.exact),
        ]);
        return {'totalSchools': r[0], 'activeSchools': r[1], 'inactiveSchools': r[2], 'totalUsers': r[3]};
      });

  Future<List<Json>> schools() => _run(() async {
        final rows = await _db.from('schools').select('*, profiles(count)').order('created_at', ascending: false);
        return [
          for (final s in rows)
            {...s, 'user_count': ((s['profiles'] as List?)?.firstOrNull as Map?)?['count'] ?? 0}..remove('profiles'),
        ];
      });

  Future<Json?> school(String id) => _run(() => _db.from('schools').select().eq('id', id).maybeSingle());

  Future<String> createSchool(Json values) => _run(() async => (await _db.from('schools').insert(values).select('id').single())['id'] as String);

  /// `.select().single()` makes an RLS-filtered update fail visibly ("not found").
  Future<void> updateSchool(String id, Json values) => _run(() => _db.from('schools').update(values).eq('id', id).select('id').single());

  /// Feature catalog merged with one school's flags (as the web shows it).
  Future<List<Json>> schoolFeatures(String schoolId) => _run(() async {
        final r = await Future.wait([
          _db.from('features').select().order('name'),
          _db.from('school_features').select('feature_key, enabled').eq('school_id', schoolId),
        ]);
        final enabled = {for (final f in r[1]) f['feature_key']: f['enabled'] == true};
        return [
          for (final f in r[0])
            {'key': f['key'], 'name': f['name'], 'description': f['description'], 'enabled': enabled[f['key']] ?? false, 'availability': f['availability'] ?? 'available'},
        ];
      });

  Future<void> setFeature(String schoolId, String key, bool enabled) => _run(() => _db
      .from('school_features')
      .upsert({'school_id': schoolId, 'feature_key': key, 'enabled': enabled}, onConflict: 'school_id,feature_key')
      .select('id')
      .single());

  Future<List<Json>> featureCatalog() => _run(() => _db.from('features').select().order('name'));

  /// Latest 500 accounts (all schools, or one school), like the web.
  Future<List<Json>> users({String? schoolId}) => _run(() async {
        var q = _db.from('profiles').select('*, school:schools(name, code)');
        if (schoolId != null) q = q.eq('school_id', schoolId);
        return await q.order('created_at', ascending: false).limit(500);
      });

  Future<void> setUserStatus(String profileId, String status) =>
      _run(() => _db.from('profiles').update({'status': status}).eq('id', profileId).select('id').single());

  /// Creating an account needs the service key, which never ships in the app:
  /// the web's /api/mobile/users does it, with the same checks as the web form.
  /// Returns null on success, or the server's {error, fieldErrors}.
  Future<Json?> provisionUser(String schoolId, Json values) async {
    if (_webUrl.isEmpty) throw const AppError(AppErrorKind.server, 'The web app address is not configured in this build.');
    var session = _db.auth.currentSession;
    if (session == null) throw const AppError(AppErrorKind.signedOut, 'Your session has ended. Please sign in again.');
    try {
      if (session.isExpired) session = (await _db.auth.refreshSession()).session ?? session;
      final client = HttpClient()..connectionTimeout = const Duration(seconds: 15);
      try {
        final req = await client.postUrl(Uri.parse('$_webUrl/api/mobile/users'));
        req.headers
          ..contentType = ContentType.json
          ..set(HttpHeaders.authorizationHeader, 'Bearer ${session.accessToken}');
        req.write(jsonEncode({...values, 'school_id': schoolId}));
        final res = await req.close().timeout(const Duration(seconds: 30));
        final body = await res.transform(utf8.decoder).join();
        final json = body.isEmpty ? <String, dynamic>{} : (jsonDecode(body) as Map).cast<String, dynamic>();
        if (res.statusCode == 201 && json['ok'] == true) return null;
        if (res.statusCode == 401) throw const AppError(AppErrorKind.signedOut, 'Your session has ended. Please sign in again.');
        if (json['error'] is String) return json;
        throw AppError(AppErrorKind.server, 'Something went wrong on the server. Please try again.', 'HTTP ${res.statusCode}');
      } finally {
        client.close();
      }
    } catch (e) {
      throw toAppError(e);
    }
  }

  static const _logoMarker = '/storage/v1/object/public/school-logos/';

  /// Same flow as the web: upload to `school-logos/<school>/<uuid>.<ext>`
  /// (Storage RLS + bucket limits decide), record it on the school, then
  /// delete the picture it replaces. `bytes == null` removes the logo.
  Future<void> setLogo(String schoolId, {Uint8List? bytes, String? ext, String? oldUrl}) => _run(() async {
        final bucket = _db.storage.from('school-logos');
        String? path;
        String? url;
        if (bytes != null) {
          path = '$schoolId/${const Uuid().v4()}.$ext';
          final mime = {'png': 'image/png', 'jpg': 'image/jpeg', 'webp': 'image/webp'}[ext]!;
          await bucket.uploadBinary(path, bytes, fileOptions: FileOptions(contentType: mime));
          url = bucket.getPublicUrl(path);
        }
        try {
          await updateSchool(schoolId, {'logo_url': url});
        } catch (_) {
          if (path != null) await bucket.remove([path]).catchError((_) => <FileObject>[]);
          rethrow;
        }
        final old = oldUrl?.split(_logoMarker).elementAtOrNull(1);
        if (old != null && old != path) await bucket.remove([Uri.decodeComponent(old)]).catchError((_) => <FileObject>[]);
      });
}

final platformApiProvider = Provider<PlatformApi>((ref) => PlatformApi(ref.watch(supabaseProvider), ref.watch(appConfigProvider).webUrl));

final platformStatsProvider = FutureProvider.autoDispose<Json>((ref) => ref.watch(platformApiProvider).stats());
final platformSchoolsProvider = FutureProvider.autoDispose<List<Json>>((ref) => ref.watch(platformApiProvider).schools());
final platformSchoolProvider = FutureProvider.autoDispose.family<Json?, String>((ref, id) => ref.watch(platformApiProvider).school(id));
final platformSchoolFeaturesProvider = FutureProvider.autoDispose.family<List<Json>, String>((ref, id) => ref.watch(platformApiProvider).schoolFeatures(id));
final platformUsersProvider = FutureProvider.autoDispose.family<List<Json>, String?>((ref, schoolId) => ref.watch(platformApiProvider).users(schoolId: schoolId));
final featureCatalogProvider = FutureProvider.autoDispose<List<Json>>((ref) => ref.watch(platformApiProvider).featureCatalog());
