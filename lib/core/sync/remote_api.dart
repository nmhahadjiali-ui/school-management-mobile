import 'package:supabase_flutter/supabase_flutter.dart';

typedef Json = Map<String, dynamic>;

/// Everything the app asks the backend. It is the SAME Supabase API the web
/// app uses — every call runs under the signed-in user's Row Level Security,
/// and writes go through the same database functions. An interface so the
/// sync engine can be tested against a fake server.
abstract class RemoteApi {
  Future<Json?> myContext();
  Future<List<Json>> notifications({int limit = 100});
  Future<void> markNotificationsRead(List<String> ids);
  Future<List<Json>> announcements({int limit = 50});
  Future<List<Json>> sections(String yearId);
  Future<List<Json>> enrollments(String yearId, List<String> sectionIds);
  Future<List<Json>> visibleStudents();
  Future<List<Json>> scheduleForTeacher(String teacherId, String yearId);
  Future<List<Json>> scheduleForSections(List<String> sectionIds, String yearId);
  Future<List<Json>> attendanceSheets(List<String> sectionIds, String sinceDate);
  Future<List<Json>> attendanceForStudents(List<String> studentIds, String sinceDate);
  Future<List<Json>> grades({String? teacherId, List<String>? studentIds, required String yearId});
  Future<List<Json>> assignments({String? teacherId, List<String>? sectionIds, required String yearId});
  Future<List<Json>> charges(List<String> studentIds);
  Future<List<Json>> payments(List<String> studentIds);
  Future<Json?> financeOverview(String schoolId, String? yearId);
  Future<List<Json>> searchStudents(String query);

  /// Offline attendance: idempotent by [opId]; conflicts are reported, not overwritten.
  Future<Json> syncAttendance({required String opId, required String sectionId, required String date, required List<Json> records});

  Future<void> registerDevice({required String token, required String platform, String? appVersion});
  Future<void> removeDevice(String token);
}

class SupabaseRemoteApi implements RemoteApi {
  SupabaseRemoteApi(this._db);

  final SupabaseClient _db;

  List<Json> _rows(dynamic data) => (data as List).cast<Map>().map((e) => e.cast<String, dynamic>()).toList();

  @override
  Future<Json?> myContext() async {
    final data = await _db.rpc('get_my_context');
    return data == null ? null : (data as Map).cast<String, dynamic>();
  }

  @override
  Future<List<Json>> notifications({int limit = 100}) async => _rows(await _db
      .from('notifications')
      .select('id, type, title, message, data, priority, read_at, created_at')
      .eq('show_in_app', true)
      .isFilter('dismissed_at', null)
      .order('created_at', ascending: false)
      .limit(limit));

  @override
  Future<void> markNotificationsRead(List<String> ids) async {
    if (ids.isEmpty) return;
    await _db.from('notifications').update({'read_at': DateTime.now().toUtc().toIso8601String()}).inFilter('id', ids).isFilter('read_at', null);
  }

  @override
  Future<List<Json>> announcements({int limit = 50}) async => _rows(await _db
      .from('announcements')
      .select('id, title, content, priority, published_at, expires_at')
      .eq('status', 'published')
      .order('published_at', ascending: false)
      .limit(limit));

  @override
  Future<List<Json>> sections(String yearId) async => _rows(await _db
      .from('sections')
      .select('id, name, academic_year_id, grade_level:grade_levels!sections_grade_level_fkey(name)')
      .eq('academic_year_id', yearId)
      .order('name'));

  @override
  Future<List<Json>> enrollments(String yearId, List<String> sectionIds) async {
    if (sectionIds.isEmpty) return [];
    return _rows(await _db
        .from('student_enrollments')
        .select('id, student_id, section_id, academic_year_id, student:students!student_enrollments_student_fkey(id, student_number, first_name, last_name)')
        .eq('academic_year_id', yearId)
        .eq('enrollment_status', 'enrolled')
        .inFilter('section_id', sectionIds));
  }

  @override
  Future<List<Json>> visibleStudents() async =>
      _rows(await _db.from('students').select('id, student_number, first_name, last_name').eq('status', 'active').order('last_name').limit(50));

  static const _scheduleSelect =
      'id, section_id, subject_id, day_of_week, start_time, end_time, room, section:sections!class_schedules_section_ref(name), subject:subjects!class_schedules_subject_ref(name), teacher:teachers!class_schedules_teacher_ref(first_name, last_name)';

  @override
  Future<List<Json>> scheduleForTeacher(String teacherId, String yearId) async =>
      _rows(await _db.from('class_schedules').select(_scheduleSelect).eq('teacher_id', teacherId).eq('academic_year_id', yearId).eq('status', 'active'));

  @override
  Future<List<Json>> scheduleForSections(List<String> sectionIds, String yearId) async {
    if (sectionIds.isEmpty) return [];
    return _rows(await _db.from('class_schedules').select(_scheduleSelect).inFilter('section_id', sectionIds).eq('academic_year_id', yearId).eq('status', 'active'));
  }

  @override
  Future<List<Json>> attendanceSheets(List<String> sectionIds, String sinceDate) async {
    if (sectionIds.isEmpty) return [];
    return _rows(await _db
        .from('attendance_sessions')
        .select('id, section_id, attendance_date, session_type, records:attendance_records(student_id, enrollment_id, status, remarks, updated_at)')
        .inFilter('section_id', sectionIds)
        .eq('session_type', 'daily')
        .gte('attendance_date', sinceDate));
  }

  @override
  Future<List<Json>> attendanceForStudents(List<String> studentIds, String sinceDate) async {
    if (studentIds.isEmpty) return [];
    return _rows(await _db
        .from('attendance_records')
        .select('student_id, enrollment_id, section_id, status, remarks, updated_at, session:attendance_sessions!attendance_records_session_fkey(attendance_date, session_type)')
        .inFilter('student_id', studentIds)
        .gte('session.attendance_date', sinceDate)
        .not('session', 'is', null));
  }

  @override
  Future<List<Json>> grades({String? teacherId, List<String>? studentIds, required String yearId}) async {
    var q = _db
        .from('grade_records')
        .select('id, student_id, section_id, score, status, subject:subjects!grade_records_subject_ref(name), period:grading_periods!grade_records_period_fkey(name, sequence)')
        .eq('academic_year_id', yearId);
    if (teacherId != null) q = q.eq('teacher_id', teacherId);
    if (studentIds != null) {
      if (studentIds.isEmpty) return [];
      q = q.inFilter('student_id', studentIds);
    }
    return _rows(await q.limit(1000));
  }

  @override
  Future<List<Json>> assignments({String? teacherId, List<String>? sectionIds, required String yearId}) async {
    var q = _db
        .from('assignments')
        .select('id, section_id, title, description, due_at, status, section:sections!assignments_section_ref(name), subject:subjects!assignments_subject_ref(name), teacher:teachers!assignments_teacher_ref(first_name, last_name)')
        .eq('academic_year_id', yearId);
    if (teacherId != null) q = q.eq('teacher_id', teacherId);
    if (sectionIds != null) {
      if (sectionIds.isEmpty) return [];
      q = q.inFilter('section_id', sectionIds).eq('status', 'published');
    }
    return _rows(await q.order('due_at', ascending: true).limit(200));
  }

  @override
  Future<List<Json>> charges(List<String> studentIds) async {
    if (studentIds.isEmpty) return [];
    return _rows(await _db
        .from('student_charge_balances')
        .select('id, student_id, description, due_date, net_amount, paid, remaining, effective_status')
        .inFilter('student_id', studentIds)
        .neq('effective_status', 'cancelled')
        .order('due_date'));
  }

  @override
  Future<List<Json>> payments(List<String> studentIds) async {
    if (studentIds.isEmpty) return [];
    return _rows(await _db
        .from('payments')
        .select('id, student_id, payment_date, amount, currency, payment_method, status, receipts(receipt_number)')
        .inFilter('student_id', studentIds)
        .order('payment_date', ascending: false)
        .limit(100));
  }

  @override
  Future<Json?> financeOverview(String schoolId, String? yearId) async {
    final data = await _db.rpc('finance_overview', params: {'p_school_id': schoolId, 'p_academic_year_id': ?yearId});
    return data == null ? null : (data as Map).cast<String, dynamic>();
  }

  @override
  Future<List<Json>> searchStudents(String query) async {
    final term = query.trim().replaceAll(RegExp(r'[%_\\]'), '');
    var q = _db.from('students').select('id, student_number, first_name, last_name');
    if (term.isNotEmpty) q = q.ilike('search_text', '%${term.toLowerCase()}%');
    return _rows(await q.order('last_name').limit(20));
  }

  @override
  Future<Json> syncAttendance({required String opId, required String sectionId, required String date, required List<Json> records}) async {
    final data = await _db.rpc('sync_attendance', params: {
      'p_op_id': opId,
      'p_section_id': sectionId,
      'p_date': date,
      'p_records': records,
    });
    return (data as Map).cast<String, dynamic>();
  }

  @override
  Future<void> registerDevice({required String token, required String platform, String? appVersion}) async {
    await _db.rpc('register_device', params: {'p_push_token': token, 'p_device_type': platform, 'p_app_version': ?appVersion});
  }

  @override
  Future<void> removeDevice(String token) async {
    await _db.from('user_devices').delete().eq('push_token', token);
  }
}
