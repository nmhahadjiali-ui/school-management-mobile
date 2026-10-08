import 'dart:async';
import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';

import '../../features/attendance/attendance_repository.dart';
import '../errors/app_error.dart';
import '../network/connectivity_service.dart';
import '../session/user_context.dart';
import '../storage/local_database.dart';
import 'remote_api.dart';

enum SyncPhase { offline, idle, syncing, failed }

@immutable
class SyncStatus {
  const SyncStatus({required this.phase, this.pending = 0, this.conflicts = 0, this.failed = 0, this.lastSyncedAt, this.message});

  final SyncPhase phase;
  final int pending;
  final int conflicts;
  final int failed;
  final DateTime? lastSyncedAt;
  final String? message;

  SyncStatus copyWith({SyncPhase? phase, int? pending, int? conflicts, int? failed, DateTime? lastSyncedAt, String? message}) => SyncStatus(
        phase: phase ?? this.phase,
        pending: pending ?? this.pending,
        conflicts: conflicts ?? this.conflicts,
        failed: failed ?? this.failed,
        lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
        message: message,
      );
}

/// THE place where local and server data meet. Screens never talk to the
/// network for cached data and never push changes themselves.
///
///   syncNow():  pull (refresh the user's scoped cache)  →  push the queue
///               (oldest first)  →  record results / conflicts  →  status
///
/// Runs on: sign-in, app resume, connectivity regained, every few minutes
/// while open, and the "Sync now" button (throttled). One run at a time.
class SyncEngine {
  SyncEngine({
    required this.db,
    required this.remote,
    required this.connectivity,
    required this.contextLoader,
    DateTime Function()? clock,
    this.manualCooldown = const Duration(seconds: 15),
  })  : _clock = clock ?? DateTime.now,
        attendance = AttendanceRepository(db);

  final LocalDatabase db;
  final RemoteApi remote;
  final ConnectivityService? connectivity;

  /// Reads the cached (or fresh) user context.
  final Future<UserContext?> Function() contextLoader;
  final AttendanceRepository attendance;
  final Duration manualCooldown;
  final DateTime Function() _clock;

  final ValueNotifier<SyncStatus> status = ValueNotifier(const SyncStatus(phase: SyncPhase.idle));
  Future<void>? _running;
  DateTime? _lastManual;
  bool _closed = false;

  /// After sign-out: no further runs (the notifier stays valid for any
  /// listener still detaching, so nothing throws during teardown).
  void close() => _closed = true;

  static const maxAttempts = 8;
  static const notificationDays = 60;
  static const attendanceDays = 14;

  /// Returns false when a manual sync is refused (too soon after the last one).
  Future<bool> syncNow({bool manual = false}) async {
    if (_closed) return false;
    if (manual) {
      final last = _lastManual;
      if (last != null && _clock().difference(last) < manualCooldown) return false;
      _lastManual = _clock();
    }
    await (_running ??= _run().whenComplete(() => _running = null));
    return true;
  }

  Future<void> _run() async {
    final online = connectivity == null ? true : await connectivity!.check();
    if (!online) {
      await _publish(SyncPhase.offline);
      return;
    }
    status.value = status.value.copyWith(phase: SyncPhase.syncing);
    try {
      await pull();
      await push();
      await _publish(SyncPhase.idle, syncedAt: _clock());
    } catch (e) {
      final err = toAppError(e);
      if (kDebugMode) debugPrint('[sync] ${err.kind}: ${err.cause ?? err.message}');
      await _publish(err.isOffline ? SyncPhase.offline : SyncPhase.failed, message: err.isOffline ? null : err.message);
    }
  }

  Future<void> _publish(SyncPhase phase, {DateTime? syncedAt, String? message}) async {
    final counts = await queueCounts();
    if (syncedAt != null) await setMeta('last_synced_at', syncedAt.toIso8601String());
    status.value = status.value.copyWith(
      phase: phase,
      pending: counts['pending'] ?? 0,
      conflicts: counts['conflict'] ?? 0,
      failed: counts['failed'] ?? 0,
      lastSyncedAt: syncedAt,
      message: message,
    );
  }

  Future<Map<String, int>> queueCounts() async {
    final rows = await db.customSelect('SELECT status, count(*) AS n FROM sync_queue GROUP BY status').get();
    return {for (final r in rows) r.read<String>('status'): r.read<int>('n')};
  }

  // ---------------------------------------------------------------------------
  // PULL: refresh only what this user's role needs (never the whole school).
  // RLS on the server decides what comes back; this only chooses the scope.
  // ---------------------------------------------------------------------------
  Future<void> pull() async {
    final fresh = await remote.myContext();
    if (fresh != null) await setMeta('context', jsonEncode(fresh));
    final ctx = fresh != null ? UserContext.fromJson(fresh) : await contextLoader();
    if (ctx == null || !ctx.accessActive) return;

    await _pullNotifications(ctx);
    if (ctx.has('announcements')) await _replaceAnnouncements(await remote.announcements());

    final year = ctx.currentYearId;
    if (year == null) return;
    if (ctx.isTeacher) {
      await _pullTeacher(ctx, year);
    } else if (ctx.isFamily) {
      await _pullFamily(ctx, year);
    }
    if (ctx.isFinance && ctx.schoolId != null) {
      final overview = await remote.financeOverview(ctx.schoolId!, year);
      if (overview != null) await setMeta('finance_overview', jsonEncode(overview));
    }
  }

  Future<void> _pullNotifications(UserContext ctx) async {
    if (!ctx.has('notifications')) return;
    final rows = await remote.notifications();
    final cutoff = _clock().subtract(const Duration(days: notificationDays));
    await db.transaction(() async {
      // Upsert by server id: re-syncing never duplicates a notification.
      // A read marked on the device but not yet pushed stays read.
      final localRead = {
        for (final r in await (db.select(db.cachedNotifications)..where((t) => t.readAt.isNotNull())).get()) r.id: r.readAt,
      };
      for (final n in rows) {
        await db.into(db.cachedNotifications).insertOnConflictUpdate(CachedNotificationsCompanion.insert(
              id: n['id'] as String,
              type: n['type'] as String,
              title: n['title'] as String,
              message: n['message'] as String,
              data: Value(jsonEncode(n['data'] ?? {})),
              priority: Value(n['priority'] as String? ?? 'normal'),
              createdAt: DateTime.parse(n['created_at'] as String),
              readAt: Value(n['read_at'] == null ? localRead[n['id']] : DateTime.parse(n['read_at'] as String)),
            ));
      }
      await (db.delete(db.cachedNotifications)..where((t) => t.createdAt.isSmallerThanValue(cutoff))).go();
    });
  }

  Future<void> _replaceAnnouncements(List<Json> rows) => db.transaction(() async {
        await db.delete(db.cachedAnnouncements).go();
        for (final a in rows) {
          final expires = a['expires_at'] == null ? null : DateTime.parse(a['expires_at'] as String);
          if (expires != null && expires.isBefore(_clock())) continue;
          await db.into(db.cachedAnnouncements).insert(CachedAnnouncementsCompanion.insert(
                id: a['id'] as String,
                title: a['title'] as String,
                content: a['content'] as String,
                priority: a['priority'] as String,
                publishedAt: Value(a['published_at'] == null ? null : DateTime.parse(a['published_at'] as String)),
                expiresAt: Value(expires),
              ));
        }
      });

  Future<void> _pullTeacher(UserContext ctx, String year) async {
    // RLS limits sections to the ones the teacher advises or teaches.
    final sections = await remote.sections(year);
    final sectionIds = [for (final s in sections) s['id'] as String];
    final enrollments = await remote.enrollments(year, sectionIds);
    await _replaceRoster(sections, enrollments);
    if (ctx.has('schedules')) await _replaceSchedule(await remote.scheduleForTeacher(ctx.recordId!, year));
    if (ctx.has('attendance')) await attendance.storeServerSheets(await remote.attendanceSheets(sectionIds, _daysAgo(attendanceDays)));
    if (ctx.has('coursework')) await _replaceAssignments(await remote.assignments(teacherId: ctx.recordId, yearId: year));
    if (ctx.has('grades')) await _replaceGrades(await remote.grades(teacherId: ctx.recordId, yearId: year));
  }

  Future<void> _pullFamily(UserContext ctx, String year) async {
    // Students: themselves. Parents: their verified children (RLS).
    final students = await remote.visibleStudents();
    final studentIds = [for (final s in students) s['id'] as String];
    final sections = await remote.sections(year);
    final sectionIds = [for (final s in sections) s['id'] as String];
    final enrollments = (await remote.enrollments(year, sectionIds)).where((e) => studentIds.contains(e['student_id'])).toList();
    await _replaceRoster(sections, enrollments, extraStudents: students);
    final mySections = {for (final e in enrollments) e['section_id'] as String}.toList();
    if (ctx.has('schedules')) await _replaceSchedule(await remote.scheduleForSections(mySections, year));
    if (ctx.has('coursework')) await _replaceAssignments(await remote.assignments(sectionIds: mySections, yearId: year));
    if (ctx.has('grades')) await _replaceGrades(await remote.grades(studentIds: studentIds, yearId: year));
    if (ctx.has('attendance')) await _storeStudentAttendance(await remote.attendanceForStudents(studentIds, _daysAgo(60)));
    if (ctx.familyFinance) {
      await _replaceCharges(await remote.charges(studentIds));
      await _replacePayments(await remote.payments(studentIds));
    }
  }

  Future<void> _replaceRoster(List<Json> sections, List<Json> enrollments, {List<Json> extraStudents = const []}) => db.transaction(() async {
        await db.delete(db.cachedSections).go();
        await db.delete(db.cachedEnrollments).go();
        await db.delete(db.cachedStudents).go();
        for (final s in sections) {
          await db.into(db.cachedSections).insert(CachedSectionsCompanion.insert(
                id: s['id'] as String,
                name: s['name'] as String,
                gradeLevel: Value((s['grade_level'] as Map?)?['name'] as String? ?? ''),
                academicYearId: s['academic_year_id'] as String,
              ));
        }
        final students = <String, Json>{for (final s in extraStudents) s['id'] as String: s};
        for (final e in enrollments) {
          final st = (e['student'] as Map?)?.cast<String, dynamic>();
          if (st != null) students[st['id'] as String] = st;
          await db.into(db.cachedEnrollments).insert(CachedEnrollmentsCompanion.insert(
                id: e['id'] as String,
                studentId: e['student_id'] as String,
                sectionId: e['section_id'] as String,
                academicYearId: e['academic_year_id'] as String,
              ));
        }
        for (final s in students.values) {
          await db.into(db.cachedStudents).insert(CachedStudentsCompanion.insert(
                id: s['id'] as String,
                studentNumber: s['student_number'] as String? ?? '',
                firstName: s['first_name'] as String? ?? '',
                lastName: s['last_name'] as String? ?? '',
              ));
        }
      });

  Future<void> _replaceSchedule(List<Json> rows) => db.transaction(() async {
        await db.delete(db.cachedSchedule).go();
        for (final r in rows) {
          final teacher = (r['teacher'] as Map?)?.cast<String, dynamic>();
          await db.into(db.cachedSchedule).insert(CachedScheduleCompanion.insert(
                id: r['id'] as String,
                sectionId: r['section_id'] as String,
                sectionName: (r['section'] as Map?)?['name'] as String? ?? '',
                subjectId: r['subject_id'] as String,
                subjectName: (r['subject'] as Map?)?['name'] as String? ?? '',
                teacherName: Value(teacher == null ? '' : '${teacher['first_name']} ${teacher['last_name']}'),
                dayOfWeek: (r['day_of_week'] as num).toInt(),
                startTime: (r['start_time'] as String).substring(0, 5),
                endTime: (r['end_time'] as String).substring(0, 5),
                room: Value(r['room'] as String?),
              ));
        }
      });

  Future<void> _replaceAssignments(List<Json> rows) => db.transaction(() async {
        await db.delete(db.cachedAssignments).go();
        for (final r in rows) {
          final teacher = (r['teacher'] as Map?)?.cast<String, dynamic>();
          await db.into(db.cachedAssignments).insert(CachedAssignmentsCompanion.insert(
                id: r['id'] as String,
                sectionId: r['section_id'] as String,
                sectionName: (r['section'] as Map?)?['name'] as String? ?? '',
                subjectName: (r['subject'] as Map?)?['name'] as String? ?? '',
                teacherName: Value(teacher == null ? '' : '${teacher['first_name']} ${teacher['last_name']}'),
                title: r['title'] as String,
                description: Value(r['description'] as String?),
                dueAt: Value(r['due_at'] == null ? null : DateTime.parse(r['due_at'] as String)),
                status: r['status'] as String,
              ));
        }
      });

  Future<void> _replaceGrades(List<Json> rows) => db.transaction(() async {
        await db.delete(db.cachedGrades).go();
        for (final r in rows) {
          final period = (r['period'] as Map?)?.cast<String, dynamic>();
          await db.into(db.cachedGrades).insert(CachedGradesCompanion.insert(
                id: r['id'] as String,
                studentId: r['student_id'] as String,
                sectionId: r['section_id'] as String,
                subjectName: (r['subject'] as Map?)?['name'] as String? ?? '',
                periodName: period?['name'] as String? ?? '',
                periodSequence: Value((period?['sequence'] as num?)?.toInt() ?? 0),
                score: Value(r['score']?.toString()),
                status: r['status'] as String,
              ));
        }
      });

  Future<void> _storeStudentAttendance(List<Json> rows) => db.transaction(() async {
        for (final r in rows) {
          final session = (r['session'] as Map?)?.cast<String, dynamic>();
          if (session == null || session['session_type'] != 'daily') continue;
          await db.into(db.attendanceMarks).insertOnConflictUpdate(AttendanceMarksCompanion.insert(
                sectionId: r['section_id'] as String,
                date: session['attendance_date'] as String,
                studentId: r['student_id'] as String,
                enrollmentId: r['enrollment_id'] as String,
                serverStatus: Value(r['status'] as String?),
                serverRemarks: Value(r['remarks'] as String?),
                serverUpdatedAt: Value(r['updated_at']?.toString()),
              ));
        }
      });

  Future<void> _replaceCharges(List<Json> rows) => db.transaction(() async {
        await db.delete(db.cachedCharges).go();
        for (final r in rows) {
          await db.into(db.cachedCharges).insert(CachedChargesCompanion.insert(
                id: r['id'] as String,
                studentId: r['student_id'] as String,
                description: r['description'] as String? ?? '',
                dueDate: Value(r['due_date'] as String?),
                netAmount: '${r['net_amount']}',
                paid: '${r['paid']}',
                remaining: '${r['remaining']}',
                status: r['effective_status'] as String? ?? 'pending',
              ));
        }
      });

  Future<void> _replacePayments(List<Json> rows) => db.transaction(() async {
        await db.delete(db.cachedPayments).go();
        for (final r in rows) {
          final receipts = (r['receipts'] as List?) ?? const [];
          await db.into(db.cachedPayments).insert(CachedPaymentsCompanion.insert(
                id: r['id'] as String,
                studentId: r['student_id'] as String,
                paymentDate: r['payment_date'] as String,
                amount: '${r['amount']}',
                currency: (r['currency'] as String? ?? 'PHP').trim(),
                method: r['payment_method'] as String? ?? '',
                status: r['status'] as String? ?? '',
                receiptNumber: Value(receipts.isEmpty ? null : (receipts.first as Map)['receipt_number'] as String?),
              ));
        }
      });

  // ---------------------------------------------------------------------------
  // PUSH: the queue, oldest first. The server validates everything again.
  // ---------------------------------------------------------------------------
  Future<void> push() async {
    final queue = await (db.select(db.syncQueue)
          ..where((q) => q.status.equals('pending'))
          ..orderBy([(q) => OrderingTerm.asc(q.createdAt)]))
        .get();
    for (final op in queue) {
      await _mark(op.id, status: 'processing', attempt: true);
      try {
        var payload = jsonDecode(op.payload) as Map<String, dynamic>;
        switch (op.entityType) {
          case 'attendance':
            // Never sent before: send the sheet's CURRENT edits with their
            // current base versions (an earlier operation may have been
            // answered since this one was queued). Once sent, an operation
            // is replayed byte-for-byte, so the server can de-duplicate it.
            if (op.attemptCount == 0) {
              final fresh = await attendance.pendingPayload(payload['section_id'] as String, payload['date'] as String);
              if (fresh == null) {
                await _mark(op.id, status: 'synced'); // already covered by an earlier operation
                continue;
              }
              payload = fresh;
              await (db.update(db.syncQueue)..where((q) => q.id.equals(op.id))).write(SyncQueueCompanion(payload: Value(jsonEncode(fresh))));
            }
            final result = await remote.syncAttendance(
              opId: op.id,
              sectionId: payload['section_id'] as String,
              date: payload['date'] as String,
              records: (payload['records'] as List).cast<Map>().map((m) => m.cast<String, dynamic>()).toList(),
            );
            await attendance.applySyncResult(payload, result);
            final conflicts = (result['conflicts'] as List?)?.length ?? 0;
            await _mark(op.id,
                status: conflicts > 0 ? 'conflict' : 'synced',
                error: conflicts > 0 ? 'This record was changed elsewhere. Please review the latest version.' : null);
          case 'notification':
            // Only sets read_at where it is still empty: replays are harmless.
            await remote.markNotificationsRead((payload['ids'] as List).cast<String>());
            await _mark(op.id, status: 'synced');
          default:
            await _mark(op.id, status: 'failed', error: 'This change is not supported by this version of the app.');
        }
      } catch (e) {
        final err = toAppError(e);
        if (err.isRetryable) {
          // Network / temporary trouble: keep it for the next run, in order.
          final attempts = op.attemptCount + 1;
          await _mark(op.id,
              status: attempts >= maxAttempts ? 'failed' : 'pending',
              error: attempts >= maxAttempts ? 'Could not sync after several attempts. Tap retry.' : null);
          if (err.isOffline) rethrow; // stop pushing; nothing else will get through
        } else {
          // The server rejected it (permission, locked day, invalid data). Never
          // hidden: shown in the sync center with the server's reason.
          await _mark(op.id, status: 'failed', error: err.message);
        }
      }
    }
    // Synced receipts are only kept briefly, for the sync center.
    await (db.delete(db.syncQueue)
          ..where((q) => q.status.equals('synced') & q.lastAttemptAt.isSmallerThanValue(_clock().subtract(const Duration(days: 3)))))
        .go();
  }

  Future<void> _mark(String id, {required String status, bool attempt = false, String? error}) async {
    final op = await (db.select(db.syncQueue)..where((q) => q.id.equals(id))).getSingle();
    await (db.update(db.syncQueue)..where((q) => q.id.equals(id))).write(SyncQueueCompanion(
          status: Value(status),
          errorMessage: Value(error),
          attemptCount: attempt ? Value(op.attemptCount + 1) : const Value.absent(),
          lastAttemptAt: attempt ? Value(_clock()) : const Value.absent(),
        ));
  }

  /// Sync center: put a failed operation back in the queue.
  Future<void> retry(String id) => (db.update(db.syncQueue)..where((q) => q.id.equals(id) & q.status.equals('failed')))
      .write(const SyncQueueCompanion(status: Value('pending'), errorMessage: Value(null)));

  /// Sync center: give up a rejected change (the local edit is discarded too).
  Future<void> discard(String id) => db.transaction(() async {
        final op = await (db.select(db.syncQueue)..where((q) => q.id.equals(id))).getSingleOrNull();
        if (op == null) return;
        if (op.entityType == 'attendance') {
          final parts = op.entityId.split('|');
          await (db.update(db.attendanceMarks)
                ..where((m) => m.sectionId.equals(parts[0]) & m.date.equals(parts[1]) & m.dirty.equals(true)))
              .write(const AttendanceMarksCompanion(dirty: Value(false), conflict: Value(false), localStatus: Value(null), localRemarks: Value(null)));
        }
        await (db.delete(db.syncQueue)..where((q) => q.id.equals(id))).go();
      });

  Future<void> setMeta(String key, String value) =>
      db.into(db.metaEntries).insertOnConflictUpdate(MetaEntriesCompanion.insert(key: key, value: value, updatedAt: Value(_clock())));

  Future<String?> getMeta(String key) async => (await (db.select(db.metaEntries)..where((m) => m.key.equals(key))).getSingleOrNull())?.value;

  String _daysAgo(int n) {
    final d = _clock().subtract(Duration(days: n));
    return '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  }

  void dispose() => status.dispose();
}
