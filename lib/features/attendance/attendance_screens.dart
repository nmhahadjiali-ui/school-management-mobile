import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../core/session/session.dart';
import '../../core/storage/local_database.dart';
import '../../shared/ui.dart';
import 'attendance_repository.dart';

final teacherSectionsProvider = StreamProvider<List<CachedSection>>((ref) {
  final db = ref.watch(dbProvider);
  return (db.select(db.cachedSections)..orderBy([(s) => OrderingTerm.asc(s.gradeLevel), (s) => OrderingTerm.asc(s.name)])).watch();
});

/// Teacher: the classes they can take attendance for (cached).
class ClassesScreen extends ConsumerWidget {
  const ClassesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sections = ref.watch(teacherSectionsProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('My classes')),
      body: Column(children: [
        const SyncBanner(),
        Expanded(
          child: asyncView(sections, (list) {
            if (list.isEmpty) return const EmptyView(title: 'No classes yet', message: 'Your sections appear here after the first sync.');
            return ListView.separated(
              itemCount: list.length,
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (_, i) {
                final s = list[i];
                return ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.groups)),
                  title: Text('${s.gradeLevel} – ${s.name}'),
                  subtitle: const Text('Take attendance'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push('/attendance/${s.id}'),
                );
              },
            );
          }),
        ),
      ]),
    );
  }
}

/// Teacher: one class, one day. Saved locally first; synced by the engine.
class AttendanceSheetScreen extends ConsumerStatefulWidget {
  const AttendanceSheetScreen({super.key, required this.sectionId});
  final String sectionId;

  @override
  ConsumerState<AttendanceSheetScreen> createState() => _AttendanceSheetScreenState();
}

class _AttendanceSheetScreenState extends ConsumerState<AttendanceSheetScreen> {
  String _date = todayIso();
  final Map<String, AttendanceEdit> _edits = {};
  bool _saving = false;

  AttendanceRepository get _repo => AttendanceRepository(ref.read(dbProvider));

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.parse(_date),
      firstDate: now.subtract(const Duration(days: 60)),
      lastDate: now, // attendance cannot be recorded in advance
    );
    if (picked != null) {
      setState(() {
        _date = DateFormat('yyyy-MM-dd').format(picked);
        _edits.clear();
      });
    }
  }

  Future<void> _save(List<SheetRow> rows) async {
    setState(() => _saving = true);
    final messenger = ScaffoldMessenger.of(context);
    try {
      final changed = await _repo.saveSheet(widget.sectionId, _date, _edits);
      _edits.clear();
      final online = ref.read(onlineProvider).value ?? false;
      messenger.showSnackBar(SnackBar(
        content: Text(changed == 0
            ? 'No changes to save.'
            : online
                ? 'Saved. Syncing $changed change${changed == 1 ? '' : 's'}…'
                : "You're offline. Your changes have been saved and will sync when you're connected."),
      ));
      if (changed > 0 && online) await ref.read(syncEngineProvider).syncNow();
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final db = ref.watch(dbProvider);
    final section = ref.watch(teacherSectionsProvider).value?.where((s) => s.id == widget.sectionId).firstOrNull;
    return StreamBuilder<List<SheetRow>>(
      stream: AttendanceRepository(db).watchSheet(widget.sectionId, _date),
      builder: (context, snap) {
        final rows = snap.data ?? const <SheetRow>[];
        String statusOf(SheetRow r) => _edits[r.student.id]?.status ?? r.status ?? '';
        final unmarked = rows.where((r) => statusOf(r).isEmpty).length;
        return Scaffold(
          appBar: AppBar(
            title: Text(section == null ? 'Attendance' : '${section.gradeLevel} – ${section.name}'),
            actions: [
              TextButton.icon(onPressed: _pickDate, icon: const Icon(Icons.calendar_today, size: 18), label: Text(formatIsoDate(_date))),
            ],
          ),
          body: Column(children: [
            const SyncBanner(),
            if (snap.connectionState == ConnectionState.waiting && rows.isEmpty) const LinearProgressIndicator(),
            if (rows.isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 8, 0),
                child: Row(children: [
                  Expanded(child: Text('${rows.length} students · $unmarked unmarked')),
                  TextButton(
                    onPressed: () => setState(() {
                      for (final r in rows) {
                        if (statusOf(r).isEmpty) _edits[r.student.id] = const AttendanceEdit('present');
                      }
                    }),
                    child: const Text('Mark rest present'),
                  ),
                ]),
              ),
            Expanded(
              child: rows.isEmpty && snap.connectionState != ConnectionState.waiting
                  ? const EmptyView(title: 'No students', message: 'The roster appears after the first sync.')
                  : ListView.builder(
                      itemCount: rows.length,
                      itemBuilder: (_, i) => _StudentRow(
                        row: rows[i],
                        status: statusOf(rows[i]),
                        edited: _edits.containsKey(rows[i].student.id),
                        onChanged: (s) => setState(() => _edits[rows[i].student.id] = AttendanceEdit(s, rows[i].remarks)),
                        onResolve: (keepMine) => _repo.resolveConflict(widget.sectionId, _date, rows[i].student.id, keepMine: keepMine).then((_) {
                          if (keepMine) ref.read(syncEngineProvider).syncNow();
                        }),
                      ),
                    ),
            ),
          ]),
          bottomNavigationBar: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: FilledButton.icon(
                onPressed: _edits.isEmpty || _saving ? null : () => _save(rows),
                icon: const Icon(Icons.save),
                label: Text(_edits.isEmpty ? 'No changes' : 'Save ${_edits.length} change${_edits.length == 1 ? '' : 's'}'),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _StudentRow extends StatelessWidget {
  const _StudentRow({required this.row, required this.status, required this.edited, required this.onChanged, required this.onResolve});
  final SheetRow row;
  final String status;
  final bool edited;
  final ValueChanged<String> onChanged;
  final ValueChanged<bool> onResolve;

  static const _short = {'present': 'P', 'absent': 'A', 'late': 'L', 'excused': 'E'};
  static const _color = {'present': Colors.green, 'absent': Colors.red, 'late': Colors.orange, 'excused': Colors.blue};

  @override
  Widget build(BuildContext context) {
    final s = row.student;
    final syncState = row.conflict
        ? const Text('⚠ Sync conflict', style: TextStyle(color: Colors.red, fontSize: 12))
        : edited
            ? const Text('Not saved', style: TextStyle(color: Colors.grey, fontSize: 12))
            : row.pending
                ? const Text('⏳ Waiting to sync', style: TextStyle(color: Colors.orange, fontSize: 12))
                : row.mark?.serverStatus != null
                    ? const Text('✓ Synced', style: TextStyle(color: Colors.green, fontSize: 12))
                    : const SizedBox.shrink();
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('${s.lastName}, ${s.firstName}', style: const TextStyle(fontWeight: FontWeight.w600)),
                Text(s.studentNumber, style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ]),
            ),
            syncState,
          ]),
          const SizedBox(height: 8),
          Wrap(spacing: 8, children: [
            for (final st in attendanceStatuses)
              ChoiceChip(
                label: Text(_short[st]!),
                tooltip: capitalize(st),
                selected: status == st,
                selectedColor: _color[st]!.withValues(alpha: 0.25),
                onSelected: row.conflict ? null : (_) => onChanged(st),
              ),
          ]),
          if (row.conflict) ...[
            const SizedBox(height: 8),
            Text(
              'This record was changed elsewhere. Server: ${capitalize(row.mark?.serverStatus ?? '-')}${row.mark?.serverRemarks != null ? ' (${row.mark!.serverRemarks})' : ''}. Yours: ${capitalize(row.mark?.localStatus ?? '-')}.',
              style: const TextStyle(fontSize: 13),
            ),
            Row(children: [
              TextButton(onPressed: () => onResolve(false), child: const Text('Use server version')),
              TextButton(onPressed: () => onResolve(true), child: const Text('Keep mine')),
            ]),
          ],
        ]),
      ),
    );
  }
}

/// Student / parent: recent attendance (cached).
class AttendanceHistoryScreen extends ConsumerWidget {
  const AttendanceHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.watch(dbProvider);
    final q = db.select(db.attendanceMarks).join([innerJoin(db.cachedStudents, db.cachedStudents.id.equalsExp(db.attendanceMarks.studentId))])
      ..orderBy([OrderingTerm.desc(db.attendanceMarks.date)]);
    return Scaffold(
      appBar: AppBar(title: const Text('Attendance')),
      body: Column(children: [
        const SyncBanner(),
        Expanded(
          child: StreamBuilder(
            stream: q.watch(),
            builder: (context, snap) {
              final rows = snap.data ?? const [];
              if (rows.isEmpty) return const EmptyView(title: 'No attendance records', message: 'Records from the last 60 days appear here.');
              return ListView.separated(
                itemCount: rows.length,
                separatorBuilder: (_, _) => const Divider(height: 1),
                itemBuilder: (_, i) {
                  final m = rows[i].readTable(db.attendanceMarks);
                  final s = rows[i].readTable(db.cachedStudents);
                  return ListTile(
                    title: Text(formatIsoDate(m.date)),
                    subtitle: Text([s.firstName, if (m.serverRemarks != null) m.serverRemarks!].join(' · ')),
                    trailing: StatusChip(m.serverStatus ?? 'pending'),
                  );
                },
              );
            },
          ),
        ),
      ]),
    );
  }
}
