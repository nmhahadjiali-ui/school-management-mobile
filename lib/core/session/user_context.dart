/// The signed-in user's context, from the SAME `get_my_context()` RPC the web
/// app uses. The school always comes from the user's own profile on the
/// server — the app never lets anyone pick or type a school.
class UserContext {
  const UserContext({
    required this.raw,
    required this.role,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.schoolId,
    required this.schoolName,
    required this.timezone,
    required this.recordType,
    required this.recordId,
    required this.features,
    required this.financeLevel,
    required this.accessActive,
    required this.currentYearId,
    required this.currentYearName,
    required this.currency,
  });

  final Map<String, dynamic> raw;
  final String role;
  final String firstName;
  final String lastName;
  final String email;
  final String? schoolId;
  final String? schoolName;
  final String timezone;
  final String? recordType; // teacher | student | guardian
  final String? recordId;
  final Set<String> features;
  final String financeLevel; // admin | staff | view | none
  final bool accessActive;
  final String? currentYearId;
  final String? currentYearName;
  final String currency;

  factory UserContext.fromJson(Map<String, dynamic> j) {
    final profile = (j['profile'] as Map?)?.cast<String, dynamic>() ?? const {};
    final school = (j['school'] as Map?)?.cast<String, dynamic>();
    final record = (j['record'] as Map?)?.cast<String, dynamic>();
    final year = (j['current_academic_year'] as Map?)?.cast<String, dynamic>();
    final settings = (j['settings'] as Map?)?.cast<String, dynamic>();
    return UserContext(
      raw: j,
      role: profile['role'] as String? ?? 'student',
      firstName: profile['first_name'] as String? ?? '',
      lastName: profile['last_name'] as String? ?? '',
      email: profile['email'] as String? ?? '',
      schoolId: profile['school_id'] as String?,
      schoolName: school?['name'] as String?,
      timezone: school?['timezone'] as String? ?? 'UTC',
      recordType: record?['type'] as String?,
      recordId: record?['id'] as String?,
      features: ((j['features'] as List?) ?? const []).cast<String>().toSet(),
      financeLevel: j['finance_level'] as String? ?? 'none',
      accessActive: j['access_active'] as bool? ?? false,
      currentYearId: year?['id'] as String?,
      currentYearName: year?['name'] as String?,
      currency: ((settings?['currency'] as String?) ?? 'PHP').trim(),
    );
  }

  String get fullName => '$firstName $lastName'.trim();
  bool has(String feature) => features.contains(feature);

  bool get isTeacher => role == 'teacher' && recordType == 'teacher' && recordId != null;
  bool get isStudent => role == 'student';
  bool get isParent => role == 'parent';
  bool get isSchoolAdmin => role == 'school_admin';
  bool get isSuperAdmin => role == 'super_admin';
  bool get isFinance => financeLevel != 'none' && has('billing');
  bool get isFamily => isStudent || isParent;
  bool get familyFinance => isFamily && has('billing') && has('student_finance');

  /// What the mobile app offers. The server re-checks every one of these.
  bool get canTakeAttendance => isTeacher && has('attendance');
}
