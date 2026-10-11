import 'package:flutter_test/flutter_test.dart';
import 'package:school_mobile/core/session/user_context.dart';
import 'package:school_mobile/features/auth/welcome_splash.dart';

UserContext ctx(String role, {String? school, String? logo}) => UserContext.fromJson({
      'profile': {'role': role, 'first_name': 'Ana', 'last_name': 'Cruz', 'email': 'a@x.test', 'school_id': school == null ? null : 's1'},
      'school': school == null ? null : {'name': school, 'logo_url': logo, 'timezone': 'Asia/Manila'},
      'features': <String>[],
      'access_active': true,
    });

void main() {
  test('the splash shows the school name, the platform for super admins, a default otherwise', () {
    expect(welcomeTitle(ctx('teacher', school: 'Ranao Child Development Center')), 'Ranao Child Development Center');
    expect(welcomeTitle(ctx('super_admin')), 'Platform Administration');
    expect(welcomeTitle(null), 'School Management');
  });

  test('the school logo URL comes from the server context', () {
    expect(ctx('parent', school: 'X', logo: 'https://cdn.test/logo.png').schoolLogoUrl, 'https://cdn.test/logo.png');
    expect(ctx('parent', school: 'X').schoolLogoUrl, isNull);
  });
}
