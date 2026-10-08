import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../core/storage/local_database.dart';

const attendanceStatuses = ['present', 'absent', 'late', 'excused'];

/// One student's row on an attendance sheet (server value + local edit).
class SheetRow {
  SheetRow({required this.student, required this.enrollmentId, this.mark});

  final CachedStudent student;
  final String enrollmentId;
  final AttendanceMark? mark;

  /// What the teacher sees: their unsynced edit, else the server value.
  String? get status => mark?.localStatus ?? mark?.serverStatus;
  String? get remarks => mark?.dirty == true ? mark?.localRemarks : mark?.serverRemarks;
  bool get pending => mark?.dirty == true;
  bool get conflict => mark?.conflict == true;
}

class AttendanceEdit {
  const AttendanceEdit(this.status, [this.remarks]);
  final String status;
  final String? remarks;
}

/// Offline attendance, entirely local until the sync engine pushes it.
class AttendanceRepository {
  AttendanceRepository(this.db, {Uuid? uuid}) : _uuid = uuid ?? const Uuid();

  final LocalDatabase db;
  final Uuid _uuid;

  static String sheetKey(String sectionId, String date) => '$sectionId|$date';

  /// The cached roster of a section joined with its marks for [date] (reactive).
  Stream<List<SheetRow>> watchSheet(String sectionId, String date) {
    final q = db.select(db.cachedEnrollments).join([
      innerJoin(db.cachedStudents, db.cachedStudents.id.equalsExp(db.cachedEnrollments.studentId)),
      leftOuterJoin(
        db.attendanceMarks,
        db.attendanceMarks.studentId.equalsExp(db.cachedEnrollments.studentId) &
            db.attendanceMarks.sectionId.equals(sectionId) &
            db.attendanceMarks.date.equals(date),
      ),
    ])
      ..where(db.cachedEnrollments.sectionId.equals(sectionId))
      ..orderBy([OrderingTerm.asc(db.cachedStudents.lastName), OrderingTerm.asc(db.cachedStudents.firstName)]);
    return q.watch().map((rows) => rows
        .map((r) => SheetRow(
              student: r.readTable(db.cachedStudents),
              enrollmentId: r.readTable(db.cachedEnrollments).id,
              mark: r.readTableOrNull(db.attendanceMarks),
            ))
        .toList());
  }

  /// Saves the teacher's sheet locally and queues it for sync — works offline.
  /// The server version each edit was based on is captured NOW, so a later
  /// pull cannot make a stale edit look current (that would overwrite
  /// someone else's change silently).
  Future<int> saveSheet(String sectionId, String date, Map<String, AttendanceEdit> edits) {
    return db.transaction(() async {
      final enrollments = {
        for (final e in await (db.select(db.cachedEnrollments)..where((t) => t.sectionId.equals(sectionId))).get()) e.studentId: e,
      };
      var changed = 0;
      for (final entry in edits.entries) {
        final enrollment = enrollments[entry.key];
        if (enrollment == null) continue; // not on this roster: never sent
        if (!attendanceStatuses.contains(entry.value.status)) continue;
        final existing = await (db.select(db.attendanceMarks)
              ..where((m) => m.sectionId.equals(sectionId) & m.date.equals(date) & m.studentId.equals(entry.key)))
            .getSingleOrNull();
        final remarks = (entry.value.remarks?.trim().isEmpty ?? true) ? null : entry.value.remarks!.trim();
        final current = existing?.localStatus ?? existing?.serverStatus;
        final currentRemarks = existing?.dirty == true ? existing?.localRemarks : existing?.serverRemarks;
        if (current == entry.value.status && currentRemarks == remarks) continue;
        changed++;
        await db.into(db.attendanceMarks).insertOnConflictUpdate(AttendanceMarksCompanion(
              sectionId: Value(sectionId),
              date: Value(date),
              studentId: Value(entry.key),
              enrollmentId: Value(enrollment.id),
              serverStatus: Value(existing?.serverStatus),
              serverRemarks: Value(existing?.serverRemarks),
              serverUpdatedAt: Value(existing?.serverUpdatedAt),
              localStatus: Value(entry.value.status),
              localRemarks: Value(remarks),
              // Keep the original base if this mark already had an unsynced edit.
              baseUpdatedAt: Value(existing?.dirty == true ? existing?.baseUpdatedAt : existing?.serverUpdatedAt),
              dirty: const Value(true),
              conflict: const Value(false),
            ));
      }
      if (changed > 0) await _enqueue(sectionId, date);
      return changed;
    });
  }

  /// One queue operation per sheet. A queued operation that was never sent
  /// may be updated; once sent it is immutable (the server may have stored
  /// it under its id), so later edits get a new operation.
  /// The sheet's unsynced edits as a sync payload (null when nothing is left).
  Future<Map<String, dynamic>?> pendingPayload(String sectionId, String date) async {
    final dirty = await (db.select(db.attendanceMarks)
          ..where((m) => m.sectionId.equals(sectionId) & m.date.equals(date) & m.dirty.equals(true) & m.conflict.equals(false)))
        .get();
    if (dirty.isEmpty) return null;
    return {
      'section_id': sectionId,
      'date': date,
      'records': [
        for (final m in dirty)
          {
            'enrollment_id': m.enrollmentId,
            'student_id': m.studentId,
            'status': m.localStatus,
            'remarks': m.localRemarks,
            'base_updated_at': m.baseUpdatedAt,
          }
      ],
    };
  }

  Future<void> _enqueue(String sectionId, String date) async {
    final key = sheetKey(sectionId, date);
    final pending = await pendingPayload(sectionId, date);
    if (pending == null) return;
    final payload = jsonEncode(pending);
    final unsent = await (db.select(db.syncQueue)
          ..where((q) => q.entityType.equals('attendance') & q.entityId.equals(key) & q.status.equals('pending') & q.attemptCount.equals(0)))
        .getSingleOrNull();
    if (unsent != null) {
      await (db.update(db.syncQueue)..where((q) => q.id.equals(unsent.id))).write(SyncQueueCompanion(payload: Value(payload)));
    } else {
      await db.into(db.syncQueue).insert(SyncQueueCompanion.insert(
            id: _uuid.v4(),
            entityType: 'attendance',
            entityId: key,
            operation: 'update',
            payload: payload,
          ));
    }
  }

  /// Applies the server's answer to a pushed sheet (also used for replays).
  Future<void> applySyncResult(Map<String, dynamic> payload, Map<String, dynamic> result) {
    final sectionId = payload['section_id'] as String;
    final date = payload['date'] as String;
    final sent = {for (final r in (payload['records'] as List).cast<Map>()) r['student_id'] as String: r};
    final conflicts = {for (final c in ((result['conflicts'] as List?) ?? const []).cast<Map>()) c['student_id'] as String: c};
    final serverRows = {for (final r in ((result['records'] as List?) ?? const []).cast<Map>()) r['student_id'] as String: r};

    return db.transaction(() async {
      for (final studentId in {...sent.keys, ...serverRows.keys}) {
        final mark = await (db.select(db.attendanceMarks)
              ..where((m) => m.sectionId.equals(sectionId) & m.date.equals(date) & m.studentId.equals(studentId)))
            .getSingleOrNull();
        if (mark == null) continue;
        final server = serverRows[studentId];
        final conflict = conflicts[studentId];
        final sentRow = sent[studentId];
        // Only settle the local edit if it is still the one that was sent
        // (the teacher may have edited again while this was in flight).
        final unchangedSinceSend = sentRow != null && mark.localStatus == sentRow['status'] && mark.localRemarks == sentRow['remarks'];
        await (db.update(db.attendanceMarks)
              ..where((m) => m.sectionId.equals(sectionId) & m.date.equals(date) & m.studentId.equals(studentId)))
            .write(AttendanceMarksCompanion(
          serverStatus: Value(conflict?['server_status'] as String? ?? server?['status'] as String? ?? mark.serverStatus),
          serverRemarks: Value(conflict != null ? conflict['server_remarks'] as String? : (server != null ? server['remarks'] as String? : mark.serverRemarks)),
          serverUpdatedAt: Value(conflict?['server_updated_at']?.toString() ?? server?['updated_at']?.toString() ?? mark.serverUpdatedAt),
          conflict: Value(conflict != null && unchangedSinceSend),
          dirty: Value(conflict != null || !unchangedSinceSend ? mark.dirty : false),
          localStatus: Value(conflict != null || !unchangedSinceSend ? mark.localStatus : null),
          localRemarks: Value(conflict != null || !unchangedSinceSend ? mark.localRemarks : null),
          // Edited again while this was in flight: the newer edit is now based
          // on the version the server just accepted from us (not a conflict).
          baseUpdatedAt: Value(conflict == null && sentRow != null && !unchangedSinceSend && server != null
              ? server['updated_at']?.toString()
              : mark.baseUpdatedAt),
        ));
      }
    });
  }

  /// Conflict review: keep the device's value (resend against the server's
  /// current version) or accept the server's value.
  Future<void> resolveConflict(String sectionId, String date, String studentId, {required bool keepMine}) {
    return db.transaction(() async {
      final where = db.update(db.attendanceMarks)
        ..where((m) => m.sectionId.equals(sectionId) & m.date.equals(date) & m.studentId.equals(studentId));
      final mark = await (db.select(db.attendanceMarks)
            ..where((m) => m.sectionId.equals(sectionId) & m.date.equals(date) & m.studentId.equals(studentId)))
          .getSingle();
      if (keepMine) {
        await where.write(AttendanceMarksCompanion(conflict: const Value(false), baseUpdatedAt: Value(mark.serverUpdatedAt)));
        await _enqueue(sectionId, date);
      } else {
        await where.write(const AttendanceMarksCompanion(
          conflict: Value(false),
          dirty: Value(false),
          localStatus: Value(null),
          localRemarks: Value(null),
        ));
      }
      // The queue entry is settled once no mark of this sheet is in conflict.
      final open = await (db.select(db.attendanceMarks)
            ..where((m) => m.sectionId.equals(sectionId) & m.date.equals(date) & m.conflict.equals(true)))
          .get();
      if (open.isEmpty) {
        await (db.update(db.syncQueue)
              ..where((q) => q.entityType.equals('attendance') & q.entityId.equals(sheetKey(sectionId, date)) & q.status.equals('conflict')))
            .write(const SyncQueueCompanion(status: Value('synced'), errorMessage: Value(null)));
      }
    });
  }

  /// Server copies of recent sheets (never touches unsynced local edits).
  Future<void> storeServerSheets(List<Map<String, dynamic>> sessions) {
    return db.transaction(() async {
      for (final s in sessions) {
        final sectionId = s['section_id'] as String;
        final date = s['attendance_date'] as String;
        for (final r in ((s['records'] as List?) ?? const []).cast<Map>()) {
          final studentId = r['student_id'] as String;
          final existing = await (db.select(db.attendanceMarks)
                ..where((m) => m.sectionId.equals(sectionId) & m.date.equals(date) & m.studentId.equals(studentId)))
              .getSingleOrNull();
          await db.into(db.attendanceMarks).insertOnConflictUpdate(AttendanceMarksCompanion(
                sectionId: Value(sectionId),
                date: Value(date),
                studentId: Value(studentId),
                enrollmentId: Value(r['enrollment_id'] as String),
                serverStatus: Value(r['status'] as String?),
                serverRemarks: Value(r['remarks'] as String?),
                serverUpdatedAt: Value(r['updated_at']?.toString()),
                localStatus: Value(existing?.localStatus),
                localRemarks: Value(existing?.localRemarks),
                baseUpdatedAt: Value(existing?.baseUpdatedAt),
                dirty: Value(existing?.dirty ?? false),
                conflict: Value(existing?.conflict ?? false),
              ));
        }
      }
    });
  }
}
