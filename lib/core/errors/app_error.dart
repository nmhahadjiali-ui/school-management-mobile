import 'dart:async';
import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';

enum AppErrorKind { offline, signedOut, permission, notFound, validation, conflict, server }

/// A user-facing error. [message] is safe to show; technical details are kept
/// in [cause] for logs and never displayed (no stack traces, no SQL).
class AppError implements Exception {
  const AppError(this.kind, this.message, [this.cause]);

  final AppErrorKind kind;
  final String message;
  final Object? cause;

  bool get isOffline => kind == AppErrorKind.offline;

  /// Retrying later can help (network trouble, temporary server errors).
  bool get isRetryable => kind == AppErrorKind.offline || kind == AppErrorKind.server;

  @override
  String toString() => 'AppError($kind, $message, $cause)';

  static const offlineMessage = "You're offline. Your changes have been saved and will sync when you're connected.";
}

// Messages our database functions raise on purpose are written for users
// (e.g. "Attendance for this day is locked"); everything else is generic.
const _userFacingCodes = {'P0001', 'P0002', '22023', '23514'};

AppError toAppError(Object error) {
  if (error is AppError) return error;
  if (_isNetwork(error)) return AppError(AppErrorKind.offline, AppError.offlineMessage, error);

  if (error is AuthException) {
    final code = error.code ?? '';
    if (code == 'invalid_credentials' || error.statusCode == '400') {
      return AppError(AppErrorKind.validation, 'Invalid email or password.', error);
    }
    if (code == 'session_not_found' || code == 'refresh_token_not_found' || error.statusCode == '401') {
      return AppError(AppErrorKind.signedOut, 'Your session has ended. Please sign in again.', error);
    }
    return AppError(AppErrorKind.server, 'Sign-in failed. Please try again.', error);
  }

  if (error is PostgrestException) {
    final code = error.code ?? '';
    final msg = error.message;
    if (code == 'PGRST116') return AppError(AppErrorKind.notFound, 'This record was not found or you do not have access to it.', error);
    if (code == '42501' || msg.contains('row-level security') || msg.contains('permission denied')) {
      final own = code == '42501' && !msg.contains('row-level security') && !msg.contains('permission denied');
      return AppError(AppErrorKind.permission, own ? msg : "You don't have permission to access this information.", error);
    }
    if (_userFacingCodes.contains(code)) return AppError(AppErrorKind.validation, msg, error);
    if (code.startsWith('23')) return AppError(AppErrorKind.validation, 'Some of the information is not valid.', error);
    if (code == 'PGRST301' || code == '401') return AppError(AppErrorKind.signedOut, 'Your session has ended. Please sign in again.', error);
    return AppError(AppErrorKind.server, 'Something went wrong on the server. Please try again.', error);
  }

  return AppError(AppErrorKind.server, 'Something went wrong. Please try again.', error);
}

bool _isNetwork(Object e) {
  if (e is SocketException || e is TimeoutException || e is HttpException) return true;
  if (e is AuthRetryableFetchException) return true;
  final text = e.toString();
  return text.contains('SocketException') ||
      text.contains('Failed host lookup') ||
      text.contains('Connection refused') ||
      text.contains('Connection closed') ||
      text.contains('ClientException') ||
      text.contains('Network is unreachable');
}
