import 'dart:convert';

import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import '../../core/errors/app_error.dart';
import '../../core/routing/deep_links.dart';
import '../../core/session/session.dart';
import '../../core/storage/local_database.dart';
import '../../shared/ui.dart';

final notificationsProvider = StreamProvider<List<CachedNotification>>((ref) {
  final db = ref.watch(dbProvider);
  return (db.select(db.cachedNotifications)..orderBy([(n) => OrderingTerm.desc(n.createdAt)])).watch();
});

final announcementsProvider = StreamProvider<List<CachedAnnouncement>>((ref) {
  final db = ref.watch(dbProvider);
  return (db.select(db.cachedAnnouncements)..orderBy([(a) => OrderingTerm.desc(a.publishedAt)])).watch();
});

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  Future<void> _open(BuildContext context, WidgetRef ref, CachedNotification n) async {
    final db = ref.read(dbProvider);
    if (n.readAt == null) {
      // Marked read locally at once; the server learns it through the sync
      // queue (works offline, retried until delivered, harmless to repeat).
      await db.transaction(() async {
        await (db.update(db.cachedNotifications)..where((t) => t.id.equals(n.id))).write(CachedNotificationsCompanion(readAt: Value(DateTime.now())));
        await db.into(db.syncQueue).insert(SyncQueueCompanion.insert(
              id: const Uuid().v4(),
              entityType: 'notification',
              entityId: n.id,
              operation: 'update',
              payload: jsonEncode({'ids': [n.id]}),
            ));
      });
      ref.read(syncEngineProvider).syncNow();
    }
    final data = (jsonDecode(n.data) as Map).cast<String, dynamic>();
    if (context.mounted) context.push(routeForNotification(data, ref.read(userContextProvider).value));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) => Scaffold(
        appBar: AppBar(title: const Text('Notifications')),
        body: Column(children: [
          const SyncBanner(),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => ref.read(syncEngineProvider).syncNow(manual: true),
              child: asyncView(ref.watch(notificationsProvider), (rows) {
                if (rows.isEmpty) return ListView(children: const [SizedBox(height: 120), EmptyView(title: 'No notifications', icon: Icons.notifications_none)]);
                return ListView.separated(
                  itemCount: rows.length,
                  separatorBuilder: (_, _) => const Divider(height: 1),
                  itemBuilder: (_, i) {
                    final n = rows[i];
                    final unread = n.readAt == null;
                    return ListTile(
                      leading: Icon(unread ? Icons.circle : Icons.circle_outlined, size: 12, color: unread ? Theme.of(context).colorScheme.primary : Colors.grey),
                      title: Text(n.title, style: TextStyle(fontWeight: unread ? FontWeight.w700 : FontWeight.normal)),
                      subtitle: Text('${n.message}\n${formatDateTime(n.createdAt)}'),
                      isThreeLine: true,
                      trailing: n.priority == 'urgent' || n.priority == 'high' ? StatusChip(n.priority) : null,
                      onTap: () => _open(context, ref, n),
                    );
                  },
                );
              }),
            ),
          ),
        ]),
      );
}

class AnnouncementsScreen extends ConsumerWidget {
  const AnnouncementsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ctx = ref.watch(userContextProvider).value;
    return Scaffold(
      appBar: AppBar(title: const Text('Announcements')),
      body: Column(children: [
        const SyncBanner(),
        Expanded(
          child: asyncView(ref.watch(announcementsProvider), (rows) {
            if (rows.isEmpty) return const EmptyView(title: 'No announcements', icon: Icons.campaign_outlined);
            return ListView.separated(
              itemCount: rows.length,
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (_, i) {
                final a = rows[i];
                return ListTile(
                  title: Text(a.title),
                  subtitle: Text(a.content, maxLines: 2, overflow: TextOverflow.ellipsis),
                  trailing: a.priority == 'high' || a.priority == 'urgent' ? StatusChip(a.priority) : Text(formatDate(a.publishedAt), style: const TextStyle(fontSize: 12)),
                  onTap: () => context.push('/announcements/${a.id}'),
                );
              },
            );
          }),
        ),
        if (ctx?.isSchoolAdmin == true || ctx?.isTeacher == true)
          const Padding(
            padding: EdgeInsets.all(12),
            // Publishing needs a connection and the web editor (audiences, scheduling).
            child: Text('Write and publish announcements on the web app.', style: TextStyle(color: Colors.grey, fontSize: 13)),
          ),
      ]),
    );
  }
}

class AnnouncementDetailScreen extends ConsumerWidget {
  const AnnouncementDetailScreen({super.key, required this.id});
  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final a = ref.watch(announcementsProvider).value?.where((x) => x.id == id).firstOrNull;
    return Scaffold(
      appBar: AppBar(title: const Text('Announcement')),
      body: a == null
          ? const EmptyView(title: 'Not available', message: "This announcement was not found, has expired, or you don't have permission to see it.", icon: Icons.lock_outline)
          : ListView(padding: const EdgeInsets.all(16), children: [
              Text(a.title, style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 4),
              Text(formatDateTime(a.publishedAt), style: const TextStyle(color: Colors.grey)),
              const Divider(height: 32),
              Text(a.content, style: const TextStyle(fontSize: 16, height: 1.4)),
            ]),
    );
  }
}

/// Sync center: every queued change with its status — failures and conflicts
/// are never hidden.
class SyncCenterScreen extends ConsumerWidget {
  const SyncCenterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.watch(dbProvider);
    final engine = ref.watch(syncEngineProvider);
    final status = ref.watch(syncStatusProvider).value;
    return Scaffold(
      appBar: AppBar(title: const Text('Sync')),
      body: Column(children: [
        const SyncBanner(),
        ListTile(
          title: Text(status?.lastSyncedAt == null ? 'Not synced yet on this device' : 'Last synced ${formatDateTime(status!.lastSyncedAt)}'),
          subtitle: status?.message != null ? Text(status!.message!) : null,
          trailing: FilledButton.tonalIcon(
            onPressed: () async {
              final messenger = ScaffoldMessenger.of(context);
              final ran = await engine.syncNow(manual: true);
              if (!ran) messenger.showSnackBar(const SnackBar(content: Text('Synced moments ago. Try again shortly.')));
            },
            icon: const Icon(Icons.sync),
            label: const Text('Sync now'),
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: StreamBuilder<List<SyncQueueData>>(
            stream: (db.select(db.syncQueue)..orderBy([(q) => OrderingTerm.desc(q.createdAt)])).watch(),
            builder: (context, snap) {
              final ops = snap.data ?? const [];
              if (ops.isEmpty) return const EmptyView(title: 'All changes are synced', icon: Icons.cloud_done_outlined);
              return ListView.separated(
                itemCount: ops.length,
                separatorBuilder: (_, _) => const Divider(height: 1),
                itemBuilder: (_, i) {
                  final op = ops[i];
                  final (label, icon, color) = switch (op.status) {
                    'synced' => ('Synced', Icons.check_circle, Colors.green),
                    'conflict' => ('Sync conflict', Icons.warning_amber, Colors.red),
                    'failed' => ('Could not sync', Icons.error_outline, Colors.red),
                    'processing' => ('Syncing…', Icons.sync, Colors.blue),
                    _ => ('Waiting for connection', Icons.schedule, Colors.orange),
                  };
                  final date = op.entityId.contains('|') ? op.entityId.split('|')[1] : '';
                  return ListTile(
                    leading: Icon(icon, color: color),
                    title: Text('${capitalize(op.entityType)}${date.isNotEmpty ? ' · ${formatIsoDate(date)}' : ''}'),
                    subtitle: Text([label, if (op.errorMessage != null) op.errorMessage!, 'Saved ${formatDateTime(op.createdAt)}'].join('\n')),
                    isThreeLine: true,
                    onTap: op.status == 'conflict' && op.entityType == 'attendance' ? () => context.push('/attendance/${op.entityId.split('|')[0]}') : null,
                    trailing: op.status == 'failed'
                        ? PopupMenuButton<String>(
                            onSelected: (v) async {
                              if (v == 'retry') {
                                await engine.retry(op.id);
                                await engine.syncNow();
                              } else {
                                await engine.discard(op.id);
                              }
                            },
                            itemBuilder: (_) => const [
                              PopupMenuItem(value: 'retry', child: Text('Retry')),
                              PopupMenuItem(value: 'discard', child: Text('Discard change')),
                            ],
                          )
                        : null,
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

/// Snackbar text for an error (never a stack trace).
String friendly(Object e) => toAppError(e).message;
