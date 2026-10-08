import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:school_mobile/core/errors/app_error.dart';
import 'package:school_mobile/core/routing/deep_links.dart';
import 'package:school_mobile/core/session/user_context.dart';
import 'package:school_mobile/core/storage/local_database.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Local data protection, cross-account isolation, error messages, deep links.

void main() {
  late Directory dir;
  setUp(() async => dir = await Directory.systemTemp.createTemp('school_mobile_test'));
  tearDown(() async => dir.delete(recursive: true));

  group('encrypted, per-user local database', () {
    test('data is encrypted at rest (no readable school data in the file)', () async {
      final file = File('${dir.path}/user_a.db');
      final db = LocalDatabase.openFile(file, 'key-for-user-a');
      await db.into(db.cachedStudents).insert(CachedStudentsCompanion.insert(id: 's1', studentNumber: 'N-1', firstName: 'Juanito', lastName: 'Confidential'));
      await db.close();
      final bytes = await file.readAsBytes();
      expect(String.fromCharCodes(bytes).contains('Confidential'), isFalse);
      expect(String.fromCharCodes(bytes.take(16)).startsWith('SQLite format'), isFalse, reason: 'not a plain SQLite file');
    });

    test("another user's key cannot open the file", () async {
      final file = File('${dir.path}/user_a.db');
      final a = LocalDatabase.openFile(file, 'key-for-user-a');
      await a.into(a.metaEntries).insert(MetaEntriesCompanion.insert(key: 'k', value: 'v'));
      await a.close();
      final b = LocalDatabase.openFile(file, 'key-for-user-b');
      await expectLater(b.customSelect('SELECT count(*) FROM meta_entries').get(), throwsA(anything));
      await b.close();
    });

    test('a second user on the same device starts with an empty database', () async {
      final a = LocalDatabase.openFile(File('${dir.path}/user_a.db'), 'ka');
      await a.into(a.cachedStudents).insert(CachedStudentsCompanion.insert(id: 's1', studentNumber: 'N', firstName: 'A', lastName: 'B'));
      await a.close();
      final b = LocalDatabase.openFile(File('${dir.path}/user_b.db'), 'kb');
      expect(await b.select(b.cachedStudents).get(), isEmpty);
      await b.close();
    });

    test('wipe removes every cached row and pending change', () async {
      final db = LocalDatabase.openFile(File('${dir.path}/user_a.db'), 'ka');
      await db.into(db.cachedStudents).insert(CachedStudentsCompanion.insert(id: 's1', studentNumber: 'N', firstName: 'A', lastName: 'B'));
      await db.into(db.syncQueue).insert(SyncQueueCompanion.insert(id: 'op', entityType: 'attendance', entityId: 'x|y', operation: 'update', payload: '{}'));
      await db.wipe();
      expect(await db.select(db.cachedStudents).get(), isEmpty);
      expect(await db.select(db.syncQueue).get(), isEmpty);
      await db.close();
    });
  });

  group('user-facing errors', () {
    test('network failures read as offline, not as stack traces', () {
      final e = toAppError(const SocketException('Failed host lookup: abc.supabase.co'));
      expect(e.isOffline, isTrue);
      expect(e.message, contains("You're offline"));
    });

    test('RLS denials read as a permission message', () {
      final e = toAppError(const PostgrestException(message: 'new row violates row-level security policy for table "attendance_records"', code: '42501'));
      expect(e.kind, AppErrorKind.permission);
      expect(e.message, "You don't have permission to access this information.");
    });

    test("the server's own validation messages are shown as-is", () {
      final e = toAppError(const PostgrestException(message: 'Only teachers and school administrators can record attendance', code: '42501'));
      expect(e.message, 'Only teachers and school administrators can record attendance');
    });

    test('unknown database errors never leak details', () {
      final e = toAppError(const PostgrestException(message: 'syntax error at or near "select"', code: '42601'));
      expect(e.message.contains('syntax'), isFalse);
    });
  });

  group('deep links', () {
    final teacher = UserContext.fromJson({'profile': {'role': 'teacher'}, 'record': {'type': 'teacher', 'id': 't'}, 'access_active': true});
    final parent = UserContext.fromJson({'profile': {'role': 'parent'}, 'access_active': true});
    const id = '0f8fad5b-d9cb-469f-a165-70867728950e';

    test('notifications open the related screen', () {
      expect(routeForNotification({'entity_type': 'assignment', 'entity_id': id}, parent), '/assignments/$id');
      expect(routeForNotification({'entity_type': 'announcement', 'entity_id': id}, parent), '/announcements/$id');
      expect(routeForNotification({'entity_type': 'attendance', 'entity_id': id}, teacher), '/classes');
      expect(routeForNotification({'entity_type': 'attendance', 'entity_id': id}, parent), '/attendance');
      expect(routeForNotification({'entity_type': 'receipt', 'entity_id': id}, parent), '/finance');
    });

    test('malformed payloads fall back safely', () {
      expect(routeForNotification({'entity_type': 'assignment', 'entity_id': '../../etc'}, parent), '/assignments');
      expect(routeForNotification({'entity_type': 'nope'}, parent), '/notifications');
    });
  });

  group('school context', () {
    test('school and role come from the server context only', () {
      final ctx = UserContext.fromJson({
        'profile': {'role': 'teacher', 'school_id': 'school-a', 'first_name': 'Maria'},
        'record': {'type': 'teacher', 'id': 't1'},
        'features': ['attendance'],
        'access_active': true,
        'finance_level': 'none',
      });
      expect([ctx.schoolId, ctx.canTakeAttendance, ctx.isFinance], ['school-a', true, false]);
      final noFeature = UserContext.fromJson({'profile': {'role': 'teacher'}, 'record': {'type': 'teacher', 'id': 't1'}, 'features': <String>[]});
      expect(noFeature.canTakeAttendance, isFalse, reason: 'school feature flags are respected');
    });
  });
}
