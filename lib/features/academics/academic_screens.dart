import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/session/session.dart';
import '../../core/storage/local_database.dart';
import '../../shared/ui.dart';

// Schedule, assignments and grades — all read from the local cache, so they
// work offline. What is cached was already filtered by RLS for this user.

const _days = ['', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];

final scheduleProvider = StreamProvider<List<CachedScheduleData>>((ref) {
  final db = ref.watch(dbProvider);
  return (db.select(db.cachedSchedule)..orderBy([(s) => OrderingTerm.asc(s.dayOfWeek), (s) => OrderingTerm.asc(s.startTime)])).watch();
});

final assignmentsProvider = StreamProvider<List<CachedAssignment>>((ref) {
  final db = ref.watch(dbProvider);
  return (db.select(db.cachedAssignments)..orderBy([(a) => OrderingTerm(expression: a.dueAt, nulls: NullsOrder.last)])).watch();
});

final gradesProvider = StreamProvider<List<CachedGrade>>((ref) {
  final db = ref.watch(dbProvider);
  return (db.select(db.cachedGrades)..orderBy([(g) => OrderingTerm.asc(g.periodSequence), (g) => OrderingTerm.asc(g.subjectName)])).watch();
});

final studentsByIdProvider = StreamProvider<Map<String, CachedStudent>>((ref) {
  final db = ref.watch(dbProvider);
  return db.select(db.cachedStudents).watch().map((rows) => {for (final s in rows) s.id: s});
});

class ScheduleScreen extends ConsumerWidget {
  const ScheduleScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final today = DateTime.now().weekday;
    return Scaffold(
      appBar: AppBar(title: const Text('Schedule')),
      body: Column(children: [
        const SyncBanner(),
        Expanded(
          child: asyncView(ref.watch(scheduleProvider), (rows) {
            if (rows.isEmpty) return const EmptyView(title: 'No schedule yet', icon: Icons.event_busy);
            return ListView(children: [
              for (var day = 1; day <= 7; day++)
                if (rows.any((r) => r.dayOfWeek == day)) ...[
                  SectionHeader(day == today ? '${_days[day]} (today)' : _days[day]),
                  for (final r in rows.where((r) => r.dayOfWeek == day))
                    ListTile(
                      leading: Text('${r.startTime}\n${r.endTime}', style: const TextStyle(fontSize: 12)),
                      title: Text(r.subjectName),
                      subtitle: Text([r.sectionName, if (r.room != null) 'Room ${r.room}', if (r.teacherName.isNotEmpty) r.teacherName].join(' · ')),
                    ),
                ],
            ]);
          }),
        ),
      ]),
    );
  }
}

class AssignmentsScreen extends ConsumerWidget {
  const AssignmentsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => Scaffold(
        appBar: AppBar(title: const Text('Assignments')),
        body: Column(children: [
          const SyncBanner(),
          Expanded(
            child: asyncView(ref.watch(assignmentsProvider), (rows) {
              if (rows.isEmpty) return const EmptyView(title: 'No assignments', icon: Icons.assignment_outlined);
              return ListView.separated(
                itemCount: rows.length,
                separatorBuilder: (_, _) => const Divider(height: 1),
                itemBuilder: (_, i) {
                  final a = rows[i];
                  final overdue = a.dueAt != null && a.dueAt!.isBefore(DateTime.now());
                  return ListTile(
                    title: Text(a.title),
                    subtitle: Text('${a.subjectName} · ${a.sectionName}${a.dueAt != null ? '\nDue ${formatDateTime(a.dueAt)}' : ''}'),
                    isThreeLine: a.dueAt != null,
                    trailing: overdue ? const StatusChip('overdue') : (a.status != 'published' ? StatusChip(a.status) : null),
                    onTap: () => context.push('/assignments/${a.id}'),
                  );
                },
              );
            }),
          ),
        ]),
      );
}

class AssignmentDetailScreen extends ConsumerWidget {
  const AssignmentDetailScreen({super.key, required this.id});
  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final a = ref.watch(assignmentsProvider).value?.where((x) => x.id == id).firstOrNull;
    return Scaffold(
      appBar: AppBar(title: const Text('Assignment')),
      body: a == null
          // Not in this user's synced data: either not theirs, or not synced yet.
          ? const EmptyView(title: 'Not available', message: "This assignment was not found, or you don't have permission to see it.", icon: Icons.lock_outline)
          : ListView(padding: const EdgeInsets.all(16), children: [
              Text(a.title, style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 4),
              Text('${a.subjectName} · ${a.sectionName}${a.teacherName.isNotEmpty ? ' · ${a.teacherName}' : ''}'),
              if (a.dueAt != null) Padding(padding: const EdgeInsets.only(top: 8), child: Text('Due ${formatDateTime(a.dueAt)}', style: const TextStyle(fontWeight: FontWeight.w600))),
              const Divider(height: 32),
              Text(a.description?.isNotEmpty == true ? a.description! : 'No instructions.'),
              const SizedBox(height: 24),
              const Text('Attachments and submissions are available on the web app.', style: TextStyle(color: Colors.grey, fontSize: 13)),
            ]),
    );
  }
}

class GradesScreen extends ConsumerWidget {
  const GradesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ctx = ref.watch(userContextProvider).value;
    final students = ref.watch(studentsByIdProvider).value ?? const {};
    return Scaffold(
      appBar: AppBar(title: const Text('Grades')),
      body: Column(children: [
        const SyncBanner(),
        Expanded(
          child: asyncView(ref.watch(gradesProvider), (rows) {
            if (rows.isEmpty) {
              return EmptyView(
                title: ctx?.isFamily == true ? 'No published grades yet' : 'No grades yet',
                message: ctx?.isFamily == true ? 'Grades appear once the school approves them.' : null,
                icon: Icons.grade_outlined,
              );
            }
            final periods = rows.map((g) => g.periodName).toSet().toList();
            final showStudent = ctx?.isParent == true || ctx?.isTeacher == true;
            return ListView(children: [
              for (final p in periods) ...[
                SectionHeader(p),
                for (final g in rows.where((g) => g.periodName == p))
                  ListTile(
                    dense: true,
                    title: Text(g.subjectName),
                    subtitle: showStudent && students[g.studentId] != null ? Text('${students[g.studentId]!.firstName} ${students[g.studentId]!.lastName}') : null,
                    trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                      Text(g.score ?? '—', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                      if (ctx?.isTeacher == true) ...[const SizedBox(width: 8), StatusChip(g.status)],
                    ]),
                  ),
              ],
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text('Grade entry is available on the web app.', style: TextStyle(color: Colors.grey, fontSize: 13)),
              ),
            ]);
          }),
        ),
      ]),
    );
  }
}
