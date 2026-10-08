import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/config/app_config.dart';
import 'core/routing/deep_links.dart';
import 'core/routing/router.dart';
import 'core/security/secure_store.dart';
import 'core/session/session.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final config = AppConfig.fromEnvironment();
  final store = SecureStore();
  // Same Supabase project as the web app; the session lives in the keystore.
  await Supabase.initialize(
    url: config.supabaseUrl,
    publishableKey: config.supabaseAnonKey,
    authOptions: FlutterAuthClientOptions(localStorage: SecureSessionStorage(store), pkceAsyncStorage: SecurePkceStorage(store)),
  );
  runApp(ProviderScope(
    overrides: [appConfigProvider.overrideWithValue(config), secureStoreProvider.overrideWithValue(store)],
    child: const SchoolApp(),
  ));
}

class SchoolApp extends ConsumerStatefulWidget {
  const SchoolApp({super.key});

  @override
  ConsumerState<SchoolApp> createState() => _SchoolAppState();
}

class _SchoolAppState extends ConsumerState<SchoolApp> {
  late final AppLifecycleListener _lifecycle;
  StreamSubscription<Map<String, dynamic>>? _pushTaps;

  @override
  void initState() {
    super.initState();
    // Coming back to the app: catch up (the OS may have paused us for hours).
    _lifecycle = AppLifecycleListener(onResume: () => ref.read(sessionProvider).value?.sync.syncNow());
    // Push notification taps open the related screen (authorization is
    // re-checked there; an id alone grants nothing).
    _pushTaps = ref.read(pushSourceProvider).openedNotifications.listen((data) {
      final ctx = ref.read(sessionProvider).value == null ? null : ref.read(userContextProvider).value;
      ref.read(routerProvider).push(routeForNotification(data, ctx));
    });
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    _pushTaps?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'School Management',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: const Color(0xFF1D4ED8), useMaterial3: true),
      darkTheme: ThemeData(colorSchemeSeed: const Color(0xFF1D4ED8), brightness: Brightness.dark, useMaterial3: true),
      routerConfig: ref.watch(routerProvider),
    );
  }
}
