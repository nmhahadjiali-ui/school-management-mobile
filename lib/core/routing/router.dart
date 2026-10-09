import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/academics/academic_screens.dart';
import '../../features/attendance/attendance_screens.dart';
import '../../features/auth/login_screen.dart';
import '../../features/communication/communication_screens.dart';
import '../../features/dashboard/home_screen.dart';
import '../../features/finance/finance_screens.dart';
import '../../features/platform/platform_screens.dart';
import '../session/session.dart';

/// Re-runs redirects when the session opens or closes.
class _SessionListenable extends ChangeNotifier {
  _SessionListenable(Ref ref) {
    ref.listen(sessionProvider, (_, _) => notifyListeners());
  }
}

final routerProvider = Provider<GoRouter>((ref) {
  final refresh = _SessionListenable(ref);
  ref.onDispose(refresh.dispose);
  return GoRouter(
    initialLocation: '/home',
    refreshListenable: refresh,
    redirect: (context, state) {
      final session = ref.read(sessionProvider);
      if (session.isLoading) return null;
      final signedIn = session.value != null;
      final atAuth = state.matchedLocation == '/login' || state.matchedLocation == '/forgot-password';
      if (!signedIn) return atAuth ? null : '/login';
      if (atAuth) return '/home';
      return null;
    },
    routes: [
      GoRoute(path: '/login', builder: (_, _) => const LoginScreen()),
      GoRoute(path: '/forgot-password', builder: (_, _) => const ForgotPasswordScreen()),
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) => _MainShell(shell: shell),
        branches: [
          StatefulShellBranch(routes: [GoRoute(path: '/home', builder: (_, _) => const HomeScreen())]),
          StatefulShellBranch(routes: [GoRoute(path: '/main', builder: (_, _) => const PrimaryTab())]),
          StatefulShellBranch(routes: [GoRoute(path: '/notifications', builder: (_, _) => const _ThirdTab())]),
          StatefulShellBranch(routes: [GoRoute(path: '/more', builder: (_, _) => const MoreScreen())]),
        ],
      ),
      GoRoute(path: '/classes', builder: (_, _) => const ClassesScreen()),
      GoRoute(path: '/attendance', builder: (_, _) => const AttendanceHistoryScreen()),
      GoRoute(path: '/attendance/:sectionId', builder: (_, s) => AttendanceSheetScreen(sectionId: s.pathParameters['sectionId']!)),
      GoRoute(path: '/schedule', builder: (_, _) => const ScheduleScreen()),
      GoRoute(path: '/assignments', builder: (_, _) => const AssignmentsScreen()),
      GoRoute(path: '/assignments/:id', builder: (_, s) => AssignmentDetailScreen(id: s.pathParameters['id']!)),
      GoRoute(path: '/grades', builder: (_, _) => const GradesScreen()),
      GoRoute(path: '/announcements', builder: (_, _) => const AnnouncementsScreen()),
      GoRoute(path: '/announcements/:id', builder: (_, s) => AnnouncementDetailScreen(id: s.pathParameters['id']!)),
      GoRoute(path: '/children/:id', builder: (_, s) => ChildScreen(studentId: s.pathParameters['id']!)),
      GoRoute(path: '/sync', builder: (_, _) => const SyncCenterScreen()),
      // Super admin (the web's /platform pages). The database re-checks every action.
      GoRoute(path: '/platform/schools', builder: (_, _) => const SchoolsScreen()),
      GoRoute(path: '/platform/schools/new', builder: (_, _) => const NewSchoolScreen()),
      GoRoute(path: '/platform/schools/:id', builder: (_, s) => SchoolDetailScreen(schoolId: s.pathParameters['id']!)),
      GoRoute(path: '/platform/users', builder: (_, _) => const PlatformUsersScreen()),
      GoRoute(path: '/platform/settings', builder: (_, _) => const PlatformSettingsScreen()),
      GoRoute(
        path: '/finance',
        builder: (context, s) => Consumer(builder: (context, ref, _) {
          final ctx = ref.watch(userContextProvider).value;
          return ctx?.isFinance == true ? const FinanceStaffScreen() : FamilyFinanceScreen(studentId: s.uri.queryParameters['student']);
        }),
      ),
    ],
  );
});

class _MainShell extends ConsumerWidget {
  const _MainShell({required this.shell});
  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ctx = ref.watch(userContextProvider).value;
    final (icon, label) = PrimaryTab.labelFor(ctx);
    final unread = (ref.watch(notificationsProvider).value ?? const []).where((n) => n.readAt == null).length;
    final platform = ctx?.isSuperAdmin == true;
    return Scaffold(
      body: shell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: shell.currentIndex,
        onDestinationSelected: (i) => shell.goBranch(i, initialLocation: i == shell.currentIndex),
        destinations: [
          const NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(icon), label: label),
          if (platform)
            const NavigationDestination(icon: Icon(Icons.people_outline), selectedIcon: Icon(Icons.people), label: 'Users')
          else
            NavigationDestination(
              icon: Badge(isLabelVisible: unread > 0, label: Text('$unread'), child: const Icon(Icons.notifications_outlined)),
              label: 'Alerts',
            ),
          const NavigationDestination(icon: Icon(Icons.menu), label: 'More'),
        ],
      ),
    );
  }
}

/// Third tab: notifications, or all users for the super admin (who has no school notifications).
class _ThirdTab extends ConsumerWidget {
  const _ThirdTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) =>
      ref.watch(userContextProvider).value?.isSuperAdmin == true ? const PlatformUsersScreen() : const NotificationsScreen();
}
