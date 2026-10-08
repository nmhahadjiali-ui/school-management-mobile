import 'dart:async';

/// Where push tokens come from. The production implementation is Firebase
/// Cloud Messaging (see docs: add google-services.json + firebase_messaging
/// and return FirebaseMessaging.instance.getToken()). Until a Firebase
/// project is connected the app runs with [NoPushTokenSource]: everything
/// else — device registration, deep links from notifications — is in place.
abstract class PushTokenSource {
  Future<String?> currentToken();
  Stream<String> get tokenRefreshes;

  /// Taps on push notifications: the notification's `data` payload
  /// (`{entity_type, entity_id, ...}` — same shape as in-app notifications).
  Stream<Map<String, dynamic>> get openedNotifications;
}

class NoPushTokenSource implements PushTokenSource {
  @override
  Future<String?> currentToken() async => null;
  @override
  Stream<String> get tokenRefreshes => const Stream.empty();
  @override
  Stream<Map<String, dynamic>> get openedNotifications => const Stream.empty();
}
