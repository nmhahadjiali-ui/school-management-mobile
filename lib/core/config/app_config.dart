/// Build-time configuration, passed with
/// `flutter run --dart-define-from-file=config/<env>.json`.
///
/// Only PUBLIC client values belong here (the Supabase URL and anon key are
/// designed to be shipped in apps; Row Level Security protects the data).
/// Service-role keys, payment, SMS or email secrets must never be added:
/// anything compiled into an app can be extracted from it.
class AppConfig {
  const AppConfig({required this.supabaseUrl, required this.supabaseAnonKey, required this.webUrl});

  final String supabaseUrl;
  final String supabaseAnonKey;

  /// The web app (password reset and other web-only flows open here).
  final String webUrl;

  static AppConfig fromEnvironment() {
    const url = String.fromEnvironment('SUPABASE_URL');
    const key = String.fromEnvironment('SUPABASE_ANON_KEY');
    const web = String.fromEnvironment('WEB_URL');
    if (url.isEmpty || key.isEmpty) {
      throw StateError('Missing configuration. Run with --dart-define-from-file=config/<env>.json');
    }
    return const AppConfig(supabaseUrl: url, supabaseAnonKey: key, webUrl: web);
  }
}
