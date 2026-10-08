import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'local_database.g.dart';

// =============================================================================
// Local database (drift over SQLite3 Multiple Ciphers).
//
// * ONE ENCRYPTED FILE PER USER: `user_<uid>.db`, keyed with a random key kept
//   in the Android Keystore. Signing out deletes the file and the key, and a
//   different user always opens a different file — caches can never mix.
// * It is a CACHE plus an offline working store. The server is the truth:
//   server values are kept separately from local edits (attendance), and
//   every pending change goes through the server's own validation.
// * Money values are stored as the server's decimal STRINGS (display only).
// =============================================================================

/// Small JSON documents (context, cursors, cached summaries).
class MetaEntries extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  @override
  Set<Column> get primaryKey => {key};
}

class CachedNotifications extends Table {
  TextColumn get id => text()();
  TextColumn get type => text()();
  TextColumn get title => text()();
  TextColumn get message => text()();
  TextColumn get data => text().withDefault(const Constant('{}'))();
  TextColumn get priority => text().withDefault(const Constant('normal'))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get readAt => dateTime().nullable()();
  @override
  Set<Column> get primaryKey => {id};
}

class CachedAnnouncements extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get content => text()();
  TextColumn get priority => text()();
  DateTimeColumn get publishedAt => dateTime().nullable()();
  DateTimeColumn get expiresAt => dateTime().nullable()();
  @override
  Set<Column> get primaryKey => {id};
}

class CachedSections extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get gradeLevel => text().withDefault(const Constant(''))();
  TextColumn get academicYearId => text()();
  @override
  Set<Column> get primaryKey => {id};
}

class CachedStudents extends Table {
  TextColumn get id => text()();
  TextColumn get studentNumber => text()();
  TextColumn get firstName => text()();
  TextColumn get lastName => text()();
  @override
  Set<Column> get primaryKey => {id};
}

class CachedEnrollments extends Table {
  TextColumn get id => text()();
  TextColumn get studentId => text()();
  TextColumn get sectionId => text()();
  TextColumn get academicYearId => text()();
  @override
  Set<Column> get primaryKey => {id};
}

class CachedSchedule extends Table {
  TextColumn get id => text()();
  TextColumn get sectionId => text()();
  TextColumn get sectionName => text()();
  TextColumn get subjectId => text()();
  TextColumn get subjectName => text()();
  TextColumn get teacherName => text().withDefault(const Constant(''))();
  IntColumn get dayOfWeek => integer()(); // 1 = Monday … 7 = Sunday
  TextColumn get startTime => text()();
  TextColumn get endTime => text()();
  TextColumn get room => text().nullable()();
  @override
  Set<Column> get primaryKey => {id};
}

/// One row per student per attendance sheet (section × date). The SERVER
/// copy and the LOCAL edit are separate columns: a pull never overwrites an
/// unsynced edit, and a push sends the server version it was based on.
class AttendanceMarks extends Table {
  TextColumn get sectionId => text()();
  TextColumn get date => text()(); // yyyy-MM-dd (school day)
  TextColumn get studentId => text()();
  TextColumn get enrollmentId => text()();
  TextColumn get serverStatus => text().nullable()();
  TextColumn get serverRemarks => text().nullable()();
  TextColumn get serverUpdatedAt => text().nullable()(); // exact server string
  TextColumn get localStatus => text().nullable()();
  TextColumn get localRemarks => text().nullable()();
  /// Server version the local edit was based on (captured when the teacher saved).
  TextColumn get baseUpdatedAt => text().nullable()();
  BoolColumn get dirty => boolean().withDefault(const Constant(false))();
  BoolColumn get conflict => boolean().withDefault(const Constant(false))();
  @override
  Set<Column> get primaryKey => {sectionId, date, studentId};
}

class CachedGrades extends Table {
  TextColumn get id => text()();
  TextColumn get studentId => text()();
  TextColumn get sectionId => text()();
  TextColumn get subjectName => text()();
  TextColumn get periodName => text()();
  IntColumn get periodSequence => integer().withDefault(const Constant(0))();
  TextColumn get score => text().nullable()();
  TextColumn get status => text()();
  @override
  Set<Column> get primaryKey => {id};
}

class CachedAssignments extends Table {
  TextColumn get id => text()();
  TextColumn get sectionId => text()();
  TextColumn get sectionName => text()();
  TextColumn get subjectName => text()();
  TextColumn get teacherName => text().withDefault(const Constant(''))();
  TextColumn get title => text()();
  TextColumn get description => text().nullable()();
  DateTimeColumn get dueAt => dateTime().nullable()();
  TextColumn get status => text()();
  @override
  Set<Column> get primaryKey => {id};
}

class CachedCharges extends Table {
  TextColumn get id => text()();
  TextColumn get studentId => text()();
  TextColumn get description => text()();
  TextColumn get dueDate => text().nullable()();
  TextColumn get netAmount => text()();
  TextColumn get paid => text()();
  TextColumn get remaining => text()();
  TextColumn get status => text()();
  @override
  Set<Column> get primaryKey => {id};
}

class CachedPayments extends Table {
  TextColumn get id => text()();
  TextColumn get studentId => text()();
  TextColumn get paymentDate => text()();
  TextColumn get amount => text()();
  TextColumn get currency => text()();
  TextColumn get method => text()();
  TextColumn get status => text()();
  TextColumn get receiptNumber => text().nullable()();
  @override
  Set<Column> get primaryKey => {id};
}

/// Changes made on the device, waiting for (or reporting on) synchronization.
class SyncQueue extends Table {
  TextColumn get id => text()(); // operation id, generated here; the server de-duplicates by it
  TextColumn get entityType => text()(); // e.g. 'attendance'
  TextColumn get entityId => text()(); // e.g. '<section_id>|<date>'
  TextColumn get operation => text()(); // create | update | delete
  TextColumn get payload => text()(); // JSON
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  IntColumn get attemptCount => integer().withDefault(const Constant(0))();
  DateTimeColumn get lastAttemptAt => dateTime().nullable()();
  TextColumn get status => text().withDefault(const Constant('pending'))(); // pending|processing|synced|failed|conflict
  TextColumn get errorMessage => text().nullable()();
  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [
  MetaEntries,
  CachedNotifications,
  CachedAnnouncements,
  CachedSections,
  CachedStudents,
  CachedEnrollments,
  CachedSchedule,
  AttendanceMarks,
  CachedGrades,
  CachedAssignments,
  CachedCharges,
  CachedPayments,
  SyncQueue,
])
class LocalDatabase extends _$LocalDatabase {
  LocalDatabase(super.e);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
          await customStatement('CREATE INDEX idx_queue_status ON sync_queue (status, created_at)');
          await customStatement('CREATE INDEX idx_marks_dirty ON attendance_marks (dirty)');
          await customStatement('CREATE INDEX idx_notifications_created ON cached_notifications (created_at)');
          await customStatement('CREATE INDEX idx_enrollments_section ON cached_enrollments (section_id)');
        },
      );

  /// Encrypted, per-user database file.
  static Future<LocalDatabase> openForUser(String userId, String key) async {
    final file = await fileForUser(userId);
    return LocalDatabase(NativeDatabase.createInBackground(file, setup: (db) => _applyKey(db, key)));
  }

  /// A specific encrypted file (used by tests; production uses [openForUser]).
  static LocalDatabase openFile(File file, String key) => LocalDatabase(NativeDatabase(file, setup: (db) => _applyKey(db, key)));

  /// In-memory (sync tests). SQLite3MC cannot key memory databases;
  /// encryption is covered by the file-based tests.
  static LocalDatabase memory() => LocalDatabase(NativeDatabase.memory());

  static void _applyKey(dynamic db, String key) {
    // The key is random base64url (no quotes), so it is safe inside the pragma.
    db.execute("PRAGMA key = '$key'");
    db.execute('PRAGMA foreign_keys = ON');
    // Fails right here (not later) if the key does not match the file.
    db.execute('SELECT count(*) FROM sqlite_master');
  }

  static Future<File> fileForUser(String userId) async {
    final dir = await getApplicationSupportDirectory();
    final safe = userId.replaceAll(RegExp(r'[^a-zA-Z0-9-]'), '');
    return File(p.join(dir.path, 'user_$safe.db'));
  }

  /// Removes every cached row and pending operation (sign-out keeps nothing).
  Future<void> wipe() => transaction(() async {
        for (final table in allTables) {
          await delete(table).go();
        }
      });
}
