import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/session/session.dart';
import '../../core/session/user_context.dart';
import '../../shared/ui.dart';
import '../academics/academic_screens.dart';
import '../attendance/attendance_screens.dart';
import '../communication/communication_screens.dart';
import '../finance/finance_screens.dart';
import '../platform/platform_screens.dart';

/// Focused, role-specific home screens (not a shrunken web dashboard).
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ctxAsync = ref.watch(userContextProvider);
    // Super admin: the web's platform dashboard (online-only, nothing cached).
    if (ctxAsync.value?.isSuperAdmin == true && ctxAsync.value!.accessActive) {
      return Scaffold(
        appBar: AppBar(title: const Text('Platform Administration')),
        body: const PlatformDashboard(),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(ctxAsync.value?.schoolName ?? 'School'),
        actions: [IconButton(tooltip: 'Sync', icon: const Icon(Icons.sync), onPressed: () => context.push('/sync'))],
      ),
      body: Column(children: [
        const SyncBanner(),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () => ref.read(syncEngineProvider).syncNow(manual: true),
            child: ctxAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => ErrorView(e),
              data: (ctx) {
                if (ctx == null) {
                  return ListView(children: const [SizedBox(height: 120), EmptyView(title: 'Getting your school ready…', message: 'Connect to the internet for the first sync.', icon: Icons.cloud_download_outlined)]);
                }
                if (!ctx.accessActive) {
                  return ListView(children: const [SizedBox(height: 120), EmptyView(title: 'Account not active', message: 'Your account or school is not active. Contact your school administrator.', icon: Icons.block)]);
                }
                return ListView(padding: const EdgeInsets.only(bottom: 24), children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                    child: Text('Hello, ${ctx.firstName} (${roleLabels[ctx.role] ?? capitalize(ctx.role)})', style: Theme.of(context).textTheme.headlineSmall),
                  ),
                  if (ctx.currentYearName != null)
                    Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: Text('School year ${ctx.currentYearName}', style: const TextStyle(color: Colors.grey))),
                  ...switch (ctx) {
                    _ when ctx.isTeacher => [const _TodaysClasses(), const _UpcomingWork()],
                    _ when ctx.isStudent => [const _TodaysClasses(), const _UpcomingWork(), const _RecentGrades(), if (ctx.familyFinance) const _BalanceCard()],
                    _ when ctx.isParent => [const _Children(), const _UpcomingWork(), if (ctx.familyFinance) const _BalanceCard()],
                    _ when ctx.isFinance && !ctx.isSchoolAdmin => [const _FinanceTotals()],
                    _ when ctx.isSchoolAdmin => [if (ctx.isFinance) const _FinanceTotals(), const _AdminNote()],
                    _ => [const _AdminNote()],
                  },
                  const _LatestAnnouncements(),
                ]);
              },
            ),
          ),
        ),
      ]),
    );
  }
}

class _TodaysClasses extends ConsumerWidget {
  const _TodaysClasses();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final today = DateTime.now().weekday;
    final rows = (ref.watch(scheduleProvider).value ?? const []).where((r) => r.dayOfWeek == today).toList();
    final ctx = ref.watch(userContextProvider).value;
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      SectionHeader("Today's classes", trailing: TextButton(onPressed: () => context.push('/schedule'), child: const Text('Schedule'))),
      if (rows.isEmpty) const ListTile(title: Text('No classes today.')),
      for (final r in rows)
        ListTile(
          leading: Text(r.startTime),
          title: Text(r.subjectName),
          subtitle: Text([r.sectionName, if (r.room != null) 'Room ${r.room}'].join(' · ')),
          trailing: ctx?.canTakeAttendance == true ? const Icon(Icons.how_to_reg) : null,
          onTap: ctx?.canTakeAttendance == true ? () => context.push('/attendance/${r.sectionId}') : null,
        ),
    ]);
  }
}

class _UpcomingWork extends ConsumerWidget {
  const _UpcomingWork();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = DateTime.now();
    final rows = (ref.watch(assignmentsProvider).value ?? const []).where((a) => a.dueAt == null || a.dueAt!.isAfter(now)).take(3).toList();
    if (rows.isEmpty) return const SizedBox.shrink();
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      SectionHeader('Assignments due', trailing: TextButton(onPressed: () => context.push('/assignments'), child: const Text('All'))),
      for (final a in rows)
        ListTile(
          title: Text(a.title),
          subtitle: Text('${a.subjectName}${a.dueAt != null ? ' · due ${formatDate(a.dueAt)}' : ''}'),
          onTap: () => context.push('/assignments/${a.id}'),
        ),
    ]);
  }
}

class _RecentGrades extends ConsumerWidget {
  const _RecentGrades();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rows = (ref.watch(gradesProvider).value ?? const []).reversed.take(3).toList();
    if (rows.isEmpty) return const SizedBox.shrink();
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      SectionHeader('Recent grades', trailing: TextButton(onPressed: () => context.push('/grades'), child: const Text('All'))),
      for (final g in rows) ListTile(dense: true, title: Text(g.subjectName), subtitle: Text(g.periodName), trailing: Text(g.score ?? '—', style: const TextStyle(fontWeight: FontWeight.w700))),
    ]);
  }
}

class _Children extends ConsumerWidget {
  const _Children();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final students = (ref.watch(studentsByIdProvider).value ?? const {}).values.toList();
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      const SectionHeader('My children'),
      if (students.isEmpty) const ListTile(title: Text('No linked children yet.')),
      for (final s in students)
        ListTile(
          leading: CircleAvatar(child: Text(s.firstName.isEmpty ? '?' : s.firstName[0])),
          title: Text('${s.firstName} ${s.lastName}'),
          subtitle: Text(s.studentNumber),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => context.push('/children/${s.id}'),
        ),
    ]);
  }
}

class _BalanceCard extends ConsumerWidget {
  const _BalanceCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ctx = ref.watch(userContextProvider).value;
    final open = (ref.watch(chargesProvider).value ?? const []).where((c) => (double.tryParse(c.remaining) ?? 0) > 0);
    return Card(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: ListTile(
        leading: const Icon(Icons.account_balance_wallet_outlined),
        title: const Text('Balance due'),
        subtitle: Text(formatMoney(sumAmounts(open.map((c) => c.remaining)), ctx?.currency ?? 'PHP'), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => context.push('/finance'),
      ),
    );
  }
}

class _FinanceTotals extends ConsumerWidget {
  const _FinanceTotals();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final o = ref.watch(financeOverviewProvider).value;
    final currency = ref.watch(userContextProvider).value?.currency ?? 'PHP';
    return Card(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: ListTile(
        leading: const Icon(Icons.payments_outlined),
        title: const Text('Collected today'),
        subtitle: Text(o == null ? 'Sync to load totals' : '${formatMoney('${o['today']}', currency)} · Outstanding ${formatMoney('${o['outstanding']}', currency)}'),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => context.push('/finance'),
      ),
    );
  }
}

class _AdminNote extends StatelessWidget {
  const _AdminNote();

  @override
  Widget build(BuildContext context) => const Card(
        margin: EdgeInsets.fromLTRB(16, 16, 16, 0),
        child: ListTile(
          leading: Icon(Icons.desktop_windows_outlined),
          title: Text('Administration'),
          subtitle: Text('Use the web app for school setup, people, enrollment, reports and approvals.'),
        ),
      );
}

class _LatestAnnouncements extends ConsumerWidget {
  const _LatestAnnouncements();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rows = (ref.watch(announcementsProvider).value ?? const []).take(3).toList();
    if (rows.isEmpty) return const SizedBox.shrink();
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      SectionHeader('Announcements', trailing: TextButton(onPressed: () => context.push('/announcements'), child: const Text('All'))),
      for (final a in rows) ListTile(title: Text(a.title), subtitle: Text(a.content, maxLines: 1, overflow: TextOverflow.ellipsis), onTap: () => context.push('/announcements/${a.id}')),
    ]);
  }
}

/// Parent: one child (only children cached for this parent — RLS-filtered).
class ChildScreen extends ConsumerWidget {
  const ChildScreen({super.key, required this.studentId});
  final String studentId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(studentsByIdProvider).value?[studentId];
    final ctx = ref.watch(userContextProvider).value;
    if (s == null) {
      return Scaffold(appBar: AppBar(), body: const EmptyView(title: 'Not available', message: "This student was not found, or you don't have permission to see them.", icon: Icons.lock_outline));
    }
    return Scaffold(
      appBar: AppBar(title: Text('${s.firstName} ${s.lastName}')),
      body: ListView(children: [
        ListTile(leading: const Icon(Icons.event), title: const Text('Schedule'), onTap: () => context.push('/schedule')),
        ListTile(leading: const Icon(Icons.how_to_reg), title: const Text('Attendance'), onTap: () => context.push('/attendance')),
        ListTile(leading: const Icon(Icons.grade_outlined), title: const Text('Grades'), onTap: () => context.push('/grades')),
        ListTile(leading: const Icon(Icons.assignment_outlined), title: const Text('Assignments'), onTap: () => context.push('/assignments')),
        if (ctx?.familyFinance == true)
          ListTile(leading: const Icon(Icons.account_balance_wallet_outlined), title: const Text('Fees & payments'), onTap: () => context.push('/finance?student=$studentId')),
      ]),
    );
  }
}

/// "More": everything not in the bottom bar, filtered by role and features.
class MoreScreen extends ConsumerWidget {
  const MoreScreen({super.key});

  Future<void> _signOut(BuildContext context, WidgetRef ref) async {
    final counts = ref.read(queueCountsProvider).value ?? const {};
    final unsynced = (counts['pending'] ?? 0) + (counts['processing'] ?? 0) + (counts['conflict'] ?? 0) + (counts['failed'] ?? 0);
    final ok = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Sign out?'),
        content: Text(unsynced > 0
            ? 'You have $unsynced change${unsynced == 1 ? '' : 's'} that have not synced. Signing out deletes them from this phone. Connect and sync first to keep them.'
            : 'Your school data will be removed from this phone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(c, true), child: Text(unsynced > 0 ? 'Sign out anyway' : 'Sign out')),
        ],
      ),
    );
    if (ok == true) await ref.read(sessionProvider.notifier).signOut();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ctx = ref.watch(userContextProvider).value;
    final items = <(IconData, String, String)>[
      if (ctx?.isSuperAdmin == true) ...[
        (Icons.apartment, 'Schools', '/platform/schools'),
        (Icons.people_outline, 'Users', '/platform/users'),
        (Icons.settings_outlined, 'Platform settings', '/platform/settings'),
      ],
      if (ctx?.has('schedules') == true) (Icons.event, 'Schedule', '/schedule'),
      if (ctx?.has('coursework') == true && (ctx!.isTeacher || ctx.isFamily)) (Icons.assignment_outlined, 'Assignments', '/assignments'),
      if (ctx?.has('grades') == true && (ctx!.isTeacher || ctx.isFamily)) (Icons.grade_outlined, 'Grades', '/grades'),
      if (ctx?.has('attendance') == true && ctx!.isFamily) (Icons.how_to_reg, 'Attendance', '/attendance'),
      if (ctx?.has('announcements') == true) (Icons.campaign_outlined, 'Announcements', '/announcements'),
      if (ctx?.familyFinance == true || ctx?.isFinance == true) (Icons.account_balance_wallet_outlined, ctx!.isFinance ? 'Finance' : 'Fees & payments', '/finance'),
      (Icons.sync, 'Sync', '/sync'),
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('More')),
      body: ListView(children: [
        if (ctx != null)
          ListTile(
            leading: CircleAvatar(child: Text(ctx.firstName.isEmpty ? '?' : ctx.firstName[0])),
            title: Text(ctx.fullName),
            subtitle: Text('${roleLabels[ctx.role] ?? capitalize(ctx.role)} · ${ctx.email}'),
          ),
        const Divider(),
        for (final (icon, label, route) in items) ListTile(leading: Icon(icon), title: Text(label), onTap: () => context.push(route)),
        const Divider(),
        ListTile(leading: const Icon(Icons.logout), title: const Text('Sign out'), onTap: () => _signOut(context, ref)),
        const Padding(padding: EdgeInsets.all(16), child: Text('Version $appVersion', style: TextStyle(color: Colors.grey, fontSize: 12))),
      ]),
    );
  }
}

/// The second bottom tab adapts to the role.
class PrimaryTab extends ConsumerWidget {
  const PrimaryTab({super.key});

  static (IconData, String) labelFor(UserContext? ctx) {
    if (ctx == null) return (Icons.apps, 'Browse');
    if (ctx.isSuperAdmin) return (Icons.apartment, 'Schools');
    if (ctx.canTakeAttendance) return (Icons.how_to_reg, 'Classes');
    if (ctx.isParent) return (Icons.family_restroom, 'Children');
    if (ctx.isStudent) return (Icons.event, 'Schedule');
    if (ctx.isFinance) return (Icons.payments_outlined, 'Finance');
    return (Icons.campaign_outlined, 'Announcements');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ctx = ref.watch(userContextProvider).value;
    if (ctx == null) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    if (ctx.isSuperAdmin) return const SchoolsScreen();
    if (ctx.canTakeAttendance) return const ClassesScreen();
    if (ctx.isParent) return const _ChildrenTab();
    if (ctx.isStudent) return const ScheduleScreen();
    if (ctx.isFinance) return const FinanceStaffScreen();
    return const AnnouncementsScreen();
  }
}

class _ChildrenTab extends StatelessWidget {
  const _ChildrenTab();

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('My children')),
        body: Column(children: const [SyncBanner(), Expanded(child: SingleChildScrollView(child: _Children()))]),
      );
}
