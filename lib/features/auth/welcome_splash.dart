import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';

import '../../core/session/session.dart';
import '../../core/session/user_context.dart';

/// Shown right after signing in (and when the app opens already signed in):
/// the school's logo with its name below, then the home screen. Schools
/// without a logo, the super admin and a not-yet-synced account get the
/// app's default logo.
class WelcomeSplash extends ConsumerStatefulWidget {
  const WelcomeSplash({super.key});

  static const minimum = Duration(milliseconds: 1500);
  static const maximum = Duration(seconds: 4);

  @override
  ConsumerState<WelcomeSplash> createState() => _WelcomeSplashState();
}

class _WelcomeSplashState extends ConsumerState<WelcomeSplash> {
  final _shownAt = DateTime.now();
  Timer? _timer;
  bool _left = false;

  @override
  void initState() {
    super.initState();
    // Leave after the minimum time once the school is known, or at the latest
    // after `maximum` (e.g. offline before the first sync).
    _timer = Timer(WelcomeSplash.maximum, _leave);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _leave() {
    if (_left || !mounted) return;
    _left = true;
    // A notification tap may already have opened another screen: keep it.
    final router = GoRouter.of(context);
    if (router.routerDelegate.currentConfiguration.uri.path == '/welcome') router.go('/home');
  }

  void _scheduleLeave() {
    final rest = WelcomeSplash.minimum - DateTime.now().difference(_shownAt);
    _timer?.cancel();
    _timer = Timer(rest.isNegative ? Duration.zero : rest, _leave);
  }

  @override
  Widget build(BuildContext context) {
    final ctxAsync = ref.watch(userContextProvider);
    final ctx = ctxAsync.value;
    if (ctx != null || ctxAsync.hasError) _scheduleLeave();
    final scheme = Theme.of(context).colorScheme;
    final name = welcomeTitle(ctx);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              SizedBox.square(dimension: 128, child: _Logo(url: ctx?.isSuperAdmin == true ? null : ctx?.schoolLogoUrl)),
              const SizedBox(height: 24),
              Text(name, textAlign: TextAlign.center, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600)),
              if (ctx != null && ctx.firstName.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text('Welcome, ${ctx.firstName}', style: TextStyle(color: scheme.onSurfaceVariant)),
              ],
              const SizedBox(height: 32),
              SizedBox.square(dimension: 20, child: CircularProgressIndicator(strokeWidth: 2, color: scheme.primary)),
            ]),
          ),
        ),
      ),
    );
  }
}

/// The school logo: saved on the phone after the first download so it shows
/// offline too; the app's default logo when there is none or it cannot load.
class _Logo extends StatefulWidget {
  const _Logo({required this.url});
  final String? url;

  @override
  State<_Logo> createState() => _LogoState();
}

class _LogoState extends State<_Logo> {
  File? _file;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void didUpdateWidget(_Logo old) {
    super.didUpdateWidget(old);
    if (old.url != widget.url) _load();
  }

  Future<void> _load() async {
    final url = widget.url;
    if (url == null || !url.startsWith('https://')) return;
    final file = await _cachedLogoFile(url);
    if (await file.exists()) {
      if (mounted) setState(() => _file = file);
      return;
    }
    try {
      final client = HttpClient()..connectionTimeout = const Duration(seconds: 5);
      try {
        final res = await (await client.getUrl(Uri.parse(url))).close().timeout(const Duration(seconds: 8));
        if (res.statusCode != 200) return;
        final bytes = await res.fold<List<int>>(<int>[], (all, chunk) => all..addAll(chunk));
        if (bytes.isEmpty || bytes.length > 2 * 1024 * 1024) return;
        await file.parent.create(recursive: true);
        await file.writeAsBytes(bytes, flush: true);
        if (mounted) setState(() => _file = file);
      } finally {
        client.close();
      }
    } catch (_) {
      // Offline or unreachable: the default logo stays.
    }
  }

  @override
  Widget build(BuildContext context) {
    final fallback = FittedBox(child: Icon(Icons.school, color: Theme.of(context).colorScheme.primary));
    final file = _file;
    if (file == null) return fallback;
    return Image.file(file, fit: BoxFit.contain, errorBuilder: (_, _, _) => fallback);
  }
}

/// One file per logo URL (a new logo has a new URL), in the app's private storage.
Future<File> _cachedLogoFile(String url) async {
  final dir = await getApplicationSupportDirectory();
  final key = base64Url.encode(utf8.encode(url)).replaceAll('=', '');
  final name = key.length > 120 ? key.substring(key.length - 120) : key;
  return File('${dir.path}/logos/$name');
}

/// The title under the logo: the school's name (super admin: the platform).
String welcomeTitle(UserContext? ctx) => ctx == null ? 'School Management' : (ctx.isSuperAdmin ? 'Platform Administration' : (ctx.schoolName ?? 'School Management'));
