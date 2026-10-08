import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../core/errors/app_error.dart';
import '../core/session/session.dart';
import '../core/sync/sync_engine.dart';

// Shared widgets and formatting.

String formatDate(DateTime? d) => d == null ? '' : DateFormat.yMMMd().format(d.toLocal());
String formatDateTime(DateTime? d) => d == null ? '' : DateFormat.yMMMd().add_jm().format(d.toLocal());
String formatIsoDate(String? iso) => iso == null ? '' : DateFormat.yMMMd().format(DateTime.parse(iso));
String todayIso() => DateFormat('yyyy-MM-dd').format(DateTime.now());

/// Money arrives as the server's decimal string; it is only formatted here.
String formatMoney(String? amount, String currency) {
  final value = double.tryParse(amount ?? '') ?? 0;
  return NumberFormat.currency(name: currency, symbol: currency == 'PHP' ? '₱' : '$currency ', decimalDigits: 2).format(value);
}

String capitalize(String s) => s.isEmpty ? s : '${s[0].toUpperCase()}${s.substring(1).replaceAll('_', ' ')}';

class EmptyView extends StatelessWidget {
  const EmptyView({super.key, required this.title, this.message, this.icon = Icons.inbox_outlined});
  final String title;
  final String? message;
  final IconData icon;

  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Icon(icon, size: 48, color: Theme.of(context).colorScheme.outline),
            const SizedBox(height: 12),
            Text(title, style: Theme.of(context).textTheme.titleMedium, textAlign: TextAlign.center),
            if (message != null) ...[
              const SizedBox(height: 6),
              Text(message!, textAlign: TextAlign.center, style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant)),
            ],
          ]),
        ),
      );
}

class ErrorView extends StatelessWidget {
  const ErrorView(this.error, {super.key});
  final Object error;

  @override
  Widget build(BuildContext context) => EmptyView(title: 'Something went wrong', message: toAppError(error).message, icon: Icons.error_outline);
}

/// AsyncValue → widget with consistent loading and error states.
Widget asyncView<T>(AsyncValue<T> value, Widget Function(T data) builder) => value.when(
      data: builder,
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => ErrorView(e),
    );

class StatusChip extends StatelessWidget {
  const StatusChip(this.status, {super.key});
  final String status;

  static const _colors = {
    'present': Colors.green,
    'paid': Colors.green,
    'published': Colors.green,
    'approved': Colors.green,
    'locked': Colors.blueGrey,
    'completed': Colors.green,
    'late': Colors.orange,
    'partially_paid': Colors.orange,
    'pending': Colors.orange,
    'submitted': Colors.blue,
    'excused': Colors.blue,
    'absent': Colors.red,
    'overdue': Colors.red,
    'reversed': Colors.red,
  };

  @override
  Widget build(BuildContext context) {
    final color = _colors[status] ?? Colors.grey;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(12)),
      child: Text(capitalize(status), style: TextStyle(color: color.shade800, fontSize: 12, fontWeight: FontWeight.w600)),
    );
  }
}

/// The small connection / sync indicator shown on every main screen.
class SyncBanner extends ConsumerWidget {
  const SyncBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final engineStatus = ref.watch(syncStatusProvider).value;
    final online = ref.watch(onlineProvider).value ?? true;
    if (engineStatus == null) return const SizedBox.shrink();
    // Queue counts come straight from the database (live), not from the last run.
    final counts = ref.watch(queueCountsProvider).value ?? const {};
    final status = engineStatus.copyWith(
      pending: (counts['pending'] ?? 0) + (counts['processing'] ?? 0),
      conflicts: counts['conflict'] ?? 0,
      failed: counts['failed'] ?? 0,
      message: engineStatus.message,
    );
    final scheme = Theme.of(context).colorScheme;
    late final Color bg;
    late final IconData icon;
    late final String text;
    if (!online || status.phase == SyncPhase.offline) {
      bg = Colors.orange.shade100;
      icon = Icons.cloud_off;
      text = status.pending > 0 ? "Offline — ${status.pending} change${status.pending == 1 ? '' : 's'} will sync when connected" : 'Offline — showing saved data';
    } else if (status.phase == SyncPhase.syncing) {
      bg = scheme.primaryContainer;
      icon = Icons.sync;
      text = 'Syncing…';
    } else if (status.conflicts > 0) {
      bg = Colors.red.shade100;
      icon = Icons.warning_amber;
      text = '${status.conflicts} sync conflict${status.conflicts == 1 ? '' : 's'} — tap to review';
    } else if (status.phase == SyncPhase.failed || status.failed > 0) {
      bg = Colors.red.shade100;
      icon = Icons.error_outline;
      text = status.failed > 0 ? '${status.failed} change${status.failed == 1 ? '' : 's'} could not sync — tap to review' : (status.message ?? 'Sync failed');
    } else if (status.pending > 0) {
      bg = scheme.secondaryContainer;
      icon = Icons.schedule;
      text = '${status.pending} change${status.pending == 1 ? '' : 's'} waiting to sync';
    } else {
      return const SizedBox.shrink(); // online and up to date: stay out of the way
    }
    return Material(
      color: bg,
      child: InkWell(
        onTap: () => context.push('/sync'),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(children: [
            Icon(icon, size: 18),
            const SizedBox(width: 8),
            Expanded(child: Text(text, style: const TextStyle(fontSize: 13))),
          ]),
        ),
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  const SectionHeader(this.title, {super.key, this.trailing});
  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
        child: Row(children: [
          Expanded(child: Text(title, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700))),
          ?trailing,
        ]),
      );
}
