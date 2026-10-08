import '../session/user_context.dart';

final _uuid = RegExp(r'^[0-9a-fA-F-]{36}$');

/// Where a notification (in-app or push) leads. Payloads use the standard
/// shape from the backend: `{entity_type, entity_id, ...}`.
///
/// Having an id never grants access: destination screens only show what this
/// user's own (RLS-filtered) synced data contains, and say "not found" otherwise.
String routeForNotification(Map<String, dynamic> data, UserContext? ctx) {
  final type = data['entity_type'] as String?;
  final id = data['entity_id'] as String?;
  final validId = id != null && _uuid.hasMatch(id);
  switch (type) {
    case 'announcement':
      return validId ? '/announcements/$id' : '/announcements';
    case 'assignment':
      return validId ? '/assignments/$id' : '/assignments';
    case 'grade':
      return '/grades';
    case 'attendance':
      return ctx?.isTeacher == true ? '/classes' : '/attendance';
    case 'schedule':
      return '/schedule';
    case 'receipt':
      return '/finance';
    default:
      return '/notifications';
  }
}
