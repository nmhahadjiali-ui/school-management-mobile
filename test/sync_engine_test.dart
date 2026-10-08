import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:school_mobile/core/storage/local_database.dart';
import 'package:school_mobile/core/sync/remote_api.dart';
import 'package:school_mobile/core/sync/sync_engine.dart';
import 'package:school_mobile/features/attendance/attendance_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// The offline engine against a simulated server: queueing while offline,
// retries, idempotent replays, conflicts, rejections, cache rules.

const section = '11111111-1111-1111-1111-111111111111';
const john = '22222222-2222-2222-2222-222222222221';
const anna = '22222222-2222-2222-2222-222222222222';
const day = '2026-10-08';

class FakeServer implements RemoteApi {
  bool offline = false;
  Object? rejectWith;
  final calls = <Map<String, dynamic>>[];
  final seenOps = <String, Json>{};
  final server = <String, Json>{}; // student -> {status, remarks, updated_at}
  var clock = 0;
  List<Json> notificationRows = [];
  final readCalls = <List<String>>[];

  String _ts() => '2026-10-08T10:00:${(clock++).toString().padLeft(2, '0')}.123456+00:00';

  @override
  Future<Json> syncAttendance({required String opId, required String sectionId, required String date, required List<Json> records}) async {
    calls.add({'op': opId, 'records': records});
    if (offline) throw const SocketException('Failed host lookup');
    if (rejectWith != null) throw rejectWith!;
    if (seenOps.containsKey(opId)) return {...seenOps[opId]!, 'duplicate': true};
    final conflicts = <Json>[];
    for (final r in records) {
      final cur = server[r['student_id']];
      final base = r['base_updated_at'] as String?;
      if (cur != null && (base == null || (cur['updated_at'] as String).compareTo(base) > 0) && cur['status'] != r['status']) {
        conflicts.add({'student_id': r['student_id'], 'server_status': cur['status'], 'server_remarks': cur['remarks'], 'server_updated_at': cur['updated_at'], 'local_status': r['status']});
      } else {
        server[r['student_id'] as String] = {'status': r['status'], 'remarks': r['remarks'], 'updated_at': _ts()};
      }
    }
    final result = {
      'op_id': opId,
      'applied': records.length - conflicts.length,
      'conflicts': conflicts,
      'records': [for (final e in server.entries) {'student_id': e.key, ...e.value}],
    };
    seenOps[opId] = result;
    return {...result, 'duplicate': false};
  }

  /// Someone else changes a record on the server.
  void changeElsewhere(String student, String status) => server[student] = {'status': status, 'remarks': 'office', 'updated_at': _ts()};

  @override
  Future<Json?> myContext() async => offline ? throw const SocketException('offline') : null;
  @override
  Future<List<Json>> notifications({int limit = 100}) async => notificationRows;
  @override
  Future<void> markNotificationsRead(List<String> ids) async {
    if (offline) throw const SocketException('offline');
    readCalls.add(ids);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError(invocation.memberName.toString());
}

Future<void> seedRoster(LocalDatabase db) async {
  await db.into(db.cachedSections).insert(CachedSectionsCompanion.insert(id: section, name: 'A', academicYearId: 'y'));
  for (final (id, first) in [(john, 'John'), (anna, 'Anna')]) {
    await db.into(db.cachedStudents).insert(CachedStudentsCompanion.insert(id: id, studentNumber: 'N-$first', firstName: first, lastName: 'Doe'));
    await db.into(db.cachedEnrollments).insert(CachedEnrollmentsCompanion.insert(id: 'enr-$id', studentId: id, sectionId: section, academicYearId: 'y'));
  }
}

void main() {
  late LocalDatabase db;
  late FakeServer remote;
  late SyncEngine engine;
  late AttendanceRepository repo;

  setUp(() async {
    db = LocalDatabase.memory();
    remote = FakeServer();
    engine = SyncEngine(db: db, remote: remote, connectivity: null, contextLoader: () async => null);
    repo = engine.attendance;
    await seedRoster(db);
  });
  tearDown(() async {
    engine.dispose();
    await db.close();
  });

  Future<List<SyncQueueData>> queue() => db.select(db.syncQueue).get();
  Future<AttendanceMark> mark(String student) =>
      (db.select(db.attendanceMarks)..where((m) => m.studentId.equals(student) & m.date.equals(day))).getSingle();

  test('attendance taken offline is kept, retried, and synced once connected', () async {
    remote.offline = true;
    final changed = await repo.saveSheet(section, day, {john: const AttendanceEdit('present'), anna: const AttendanceEdit('absent', 'Fever')});
    expect(changed, 2);
    expect((await queue()).single.status, 'pending');

    await engine.push().catchError((_) {});
    final afterOffline = (await queue()).single;
    expect(afterOffline.status, 'pending', reason: 'network errors keep the change queued');
    expect(afterOffline.attemptCount, 1);
    expect((await mark(anna)).dirty, isTrue);

    remote.offline = false;
    await engine.push();
    expect((await queue()).single.status, 'synced');
    final a = await mark(anna);
    expect([a.dirty, a.serverStatus, a.serverRemarks, a.localStatus], [false, 'absent', 'Fever', null]);
    expect(remote.server[anna]!['status'], 'absent');
  });

  test('a replayed operation (lost response) is not applied twice', () async {
    await repo.saveSheet(section, day, {john: const AttendanceEdit('late')});
    final op = (await queue()).single;
    // First attempt reaches the server, but the response is "lost".
    await remote.syncAttendance(opId: op.id, sectionId: section, date: day, records: (jsonDecode(op.payload)['records'] as List).cast<Json>());
    remote.changeElsewhere(john, 'excused'); // changed later by the office
    await engine.push(); // the app retries the SAME operation
    expect(remote.calls.last['op'], op.id);
    expect(remote.server[john]!['status'], 'excused', reason: 'the replay changed nothing on the server');
    expect((await queue()).single.status, 'synced');
  });

  test('a record changed elsewhere becomes a conflict — never silently overwritten', () async {
    await repo.saveSheet(section, day, {john: const AttendanceEdit('present')});
    await engine.push();
    // Offline edit based on the synced version...
    await repo.saveSheet(section, day, {john: const AttendanceEdit('late')});
    // ...while the office changes the same record.
    remote.changeElsewhere(john, 'absent');
    await engine.push();

    final ops = await queue();
    expect(ops.where((o) => o.status == 'conflict'), hasLength(1));
    final m = await mark(john);
    expect([m.conflict, m.serverStatus, m.localStatus], [true, 'absent', 'late']);
    expect(remote.server[john]!['status'], 'absent');

    // Teacher reviews: keep mine → resent against the server's current version.
    await repo.resolveConflict(section, day, john, keepMine: true);
    await engine.push();
    expect(remote.server[john]!['status'], 'late');
    final after = await mark(john);
    expect([after.conflict, after.dirty], [false, false]);
    expect((await queue()).where((o) => o.status == 'conflict'), isEmpty);
  });

  test('"use server version" discards the local edit', () async {
    await repo.saveSheet(section, day, {john: const AttendanceEdit('present')});
    await engine.push();
    await repo.saveSheet(section, day, {john: const AttendanceEdit('late')});
    remote.changeElsewhere(john, 'absent');
    await engine.push();
    await repo.resolveConflict(section, day, john, keepMine: false);
    final m = await mark(john);
    expect([m.conflict, m.dirty, m.localStatus, m.serverStatus], [false, false, null, 'absent']);
    expect((await queue()).where((o) => o.status == 'conflict' || o.status == 'pending'), isEmpty);
  });

  test('a server rejection is shown with its reason and can be retried or discarded', () async {
    remote.rejectWith = const PostgrestException(message: 'Attendance for this day is locked', code: 'P0001');
    await repo.saveSheet(section, day, {john: const AttendanceEdit('present')});
    await engine.push();
    var op = (await queue()).single;
    expect([op.status, op.errorMessage], ['failed', 'Attendance for this day is locked']);

    remote.rejectWith = null;
    await engine.retry(op.id);
    await engine.push();
    op = (await queue()).single;
    expect(op.status, 'synced');
  });

  test('editing again before sending updates the queued change; after sending, a new one is created', () async {
    await repo.saveSheet(section, day, {john: const AttendanceEdit('present')});
    await repo.saveSheet(section, day, {anna: const AttendanceEdit('absent')});
    var ops = await queue();
    expect(ops, hasLength(1));
    expect((jsonDecode(ops.single.payload)['records'] as List), hasLength(2));

    remote.offline = true;
    await engine.push().catchError((_) {}); // sent once (attempt 1), outcome unknown
    await repo.saveSheet(section, day, {john: const AttendanceEdit('late')});
    ops = await queue();
    expect(ops, hasLength(2), reason: 'a sent operation is immutable');
  });

  test('editing while a change is in flight does not create a false conflict', () async {
    await repo.saveSheet(section, day, {john: const AttendanceEdit('present')});
    final payload = jsonDecode((await queue()).single.payload) as Map<String, dynamic>;
    final result = await remote.syncAttendance(opId: 'x', sectionId: section, date: day, records: (payload['records'] as List).cast<Json>());
    // The teacher changes John again before the response is applied.
    await repo.saveSheet(section, day, {john: const AttendanceEdit('late')});
    await repo.applySyncResult(payload, result);
    final m = await mark(john);
    expect([m.dirty, m.localStatus, m.conflict], [true, 'late', false]);
    expect(m.baseUpdatedAt, result['records'][0]['updated_at'], reason: 'rebased on the version we just wrote');
    await engine.push();
    expect(remote.server[john]!['status'], 'late');
    expect((await mark(john)).conflict, isFalse);
  });

  test('students not on the cached roster are never sent', () async {
    final n = await repo.saveSheet(section, day, {'99999999-9999-9999-9999-999999999999': const AttendanceEdit('present'), john: const AttendanceEdit('nonsense')});
    expect(n, 0);
    expect(await queue(), isEmpty);
  });

  test('notifications are not duplicated by re-syncing, and an offline "read" survives a pull', () async {
    remote.notificationRows = [
      {'id': 'n1', 'type': 'announcement', 'title': 'Hello', 'message': 'm', 'data': {}, 'priority': 'normal', 'read_at': null, 'created_at': DateTime.now().toUtc().toIso8601String()},
    ];
    final ctx = {'profile': {'role': 'student'}, 'access_active': true, 'features': ['notifications']};
    final e = SyncEngine(db: db, remote: _ContextRemote(remote, ctx), connectivity: null, contextLoader: () async => null);
    await e.pull();
    await e.pull();
    expect(await db.select(db.cachedNotifications).get(), hasLength(1));
    await (db.update(db.cachedNotifications)..where((n) => n.id.equals('n1'))).write(CachedNotificationsCompanion(readAt: Value(DateTime.now())));
    await e.pull(); // the server still says unread (not pushed yet)
    expect((await db.select(db.cachedNotifications).getSingle()).readAt, isNotNull);
    e.dispose();
  });
}

class _ContextRemote extends FakeServer {
  _ContextRemote(this.inner, this.ctx);
  final FakeServer inner;
  final Json ctx;
  @override
  Future<Json?> myContext() async => ctx;
  @override
  Future<List<Json>> notifications({int limit = 100}) => inner.notifications(limit: limit);
}
