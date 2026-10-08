import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/errors/app_error.dart';
import '../../core/session/session.dart';
import '../../core/storage/local_database.dart';
import '../../core/sync/remote_api.dart';
import '../../shared/ui.dart';

// Financial data is VIEW-ONLY on mobile. Payments are recorded on the web by
// the cashier, and online payments are confirmed only by the provider's
// server-side webhook — never by this app, and never while offline.

final chargesProvider = StreamProvider<List<CachedCharge>>((ref) {
  final db = ref.watch(dbProvider);
  return db.select(db.cachedCharges).watch();
});

final paymentsProvider = StreamProvider<List<CachedPayment>>((ref) {
  final db = ref.watch(dbProvider);
  return db.select(db.cachedPayments).watch();
});

final financeOverviewProvider = StreamProvider<Map<String, dynamic>?>((ref) {
  final db = ref.watch(dbProvider);
  return (db.select(db.metaEntries)..where((m) => m.key.equals('finance_overview')))
      .watchSingleOrNull()
      .map((r) => r == null ? null : (jsonDecode(r.value) as Map).cast<String, dynamic>());
});

/// Total of decimal strings in integer cents (display only; the server is authoritative).
String sumAmounts(Iterable<String> amounts) {
  var cents = 0;
  for (final a in amounts) {
    cents += ((double.tryParse(a) ?? 0) * 100).round();
  }
  return (cents / 100).toStringAsFixed(2);
}

/// Students / parents: balances and payment history from the last sync.
class FamilyFinanceScreen extends ConsumerWidget {
  const FamilyFinanceScreen({super.key, this.studentId});
  final String? studentId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ctx = ref.watch(userContextProvider).value;
    final currency = ctx?.currency ?? 'PHP';
    final charges = (ref.watch(chargesProvider).value ?? const []).where((c) => studentId == null || c.studentId == studentId).toList();
    final payments = (ref.watch(paymentsProvider).value ?? const []).where((p) => studentId == null || p.studentId == studentId).toList();
    final open = charges.where((c) => (double.tryParse(c.remaining) ?? 0) > 0).toList();
    final status = ref.watch(syncStatusProvider).value;
    return Scaffold(
      appBar: AppBar(title: const Text('Fees & payments')),
      body: Column(children: [
        const SyncBanner(),
        Expanded(
          child: ctx?.familyFinance != true
              ? const EmptyView(title: 'Not available', message: 'Your school has not enabled fee information in the app.', icon: Icons.lock_outline)
              : ListView(children: [
                  Card(
                    margin: const EdgeInsets.all(16),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        const Text('Balance due'),
                        Text(formatMoney(sumAmounts(open.map((c) => c.remaining)), currency), style: Theme.of(context).textTheme.headlineMedium),
                        if (status?.lastSyncedAt != null)
                          Text('As of ${formatDateTime(status!.lastSyncedAt)}', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                      ]),
                    ),
                  ),
                  const SectionHeader('Unpaid charges'),
                  if (open.isEmpty) const ListTile(title: Text('Nothing due. 🎉')),
                  for (final c in open)
                    ListTile(
                      title: Text(c.description),
                      subtitle: Text(c.dueDate == null ? '' : 'Due ${formatIsoDate(c.dueDate)}'),
                      trailing: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.end, children: [
                        Text(formatMoney(c.remaining, currency), style: const TextStyle(fontWeight: FontWeight.w600)),
                        StatusChip(c.status),
                      ]),
                    ),
                  const SectionHeader('Payments'),
                  if (payments.isEmpty) const ListTile(title: Text('No payments yet.')),
                  for (final p in payments)
                    ListTile(
                      title: Text(formatMoney(p.amount, p.currency)),
                      subtitle: Text('${formatIsoDate(p.paymentDate)} · ${capitalize(p.method)}${p.receiptNumber != null ? ' · ${p.receiptNumber}' : ''}'),
                      trailing: StatusChip(p.status),
                    ),
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text('To pay online or print a receipt, use the web app. Payments show here once the school records or confirms them.',
                        style: TextStyle(color: Colors.grey, fontSize: 13)),
                  ),
                ]),
        ),
      ]),
    );
  }
}

/// Finance staff / admins: school totals (cached) and an ONLINE student lookup.
class FinanceStaffScreen extends ConsumerStatefulWidget {
  const FinanceStaffScreen({super.key});

  @override
  ConsumerState<FinanceStaffScreen> createState() => _FinanceStaffScreenState();
}

class _FinanceStaffScreenState extends ConsumerState<FinanceStaffScreen> {
  final _query = TextEditingController();
  List<Json> _results = [];
  String? _error;
  bool _busy = false;

  @override
  void dispose() {
    _query.dispose();
    super.dispose();
  }

  Future<void> _search() async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final rows = await ref.read(remoteApiProvider).searchStudents(_query.text);
      setState(() => _results = rows);
    } catch (e) {
      final err = toAppError(e);
      setState(() => _error = err.isOffline ? 'Student lookup needs a connection.' : err.message);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ctx = ref.watch(userContextProvider).value;
    final overview = ref.watch(financeOverviewProvider).value;
    final currency = ctx?.currency ?? 'PHP';
    return Scaffold(
      appBar: AppBar(title: const Text('Finance')),
      body: Column(children: [
        const SyncBanner(),
        Expanded(
          child: ListView(children: [
            if (overview != null)
              Padding(
                padding: const EdgeInsets.all(12),
                child: Wrap(spacing: 8, runSpacing: 8, children: [
                  _Stat('Collected today', formatMoney('${overview['today']}', currency)),
                  _Stat('This month', formatMoney('${overview['this_month']}', currency)),
                  _Stat('Outstanding', formatMoney('${overview['outstanding']}', currency)),
                  _Stat('Overdue', formatMoney('${overview['overdue']}', currency)),
                ]),
              ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(children: [
                Expanded(
                  child: TextField(
                    controller: _query,
                    decoration: const InputDecoration(labelText: 'Find a student', border: OutlineInputBorder(), prefixIcon: Icon(Icons.search)),
                    onSubmitted: (_) => _search(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(onPressed: _busy ? null : _search, icon: const Icon(Icons.arrow_forward)),
              ]),
            ),
            if (_busy) const LinearProgressIndicator(),
            if (_error != null) ListTile(leading: const Icon(Icons.cloud_off), title: Text(_error!)),
            for (final s in _results)
              ListTile(
                title: Text('${s['last_name']}, ${s['first_name']}'),
                subtitle: Text('${s['student_number']}'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => _StudentAccount(student: s))),
              ),
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text('Recording payments, refunds and receipts is done on the web app, where every step is confirmed and audited.',
                  style: TextStyle(color: Colors.grey, fontSize: 13)),
            ),
          ]),
        ),
      ]),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat(this.label, this.value);
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => SizedBox(
        width: (MediaQuery.of(context).size.width - 32) / 2,
        child: Card(
          margin: EdgeInsets.zero,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
              const SizedBox(height: 4),
              Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            ]),
          ),
        ),
      );
}

/// A student's balances, fetched live (RLS: finance users of their own school only).
class _StudentAccount extends ConsumerWidget {
  const _StudentAccount({required this.student});
  final Json student;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final api = ref.read(remoteApiProvider);
    final id = student['id'] as String;
    final currency = ref.watch(userContextProvider).value?.currency ?? 'PHP';
    return Scaffold(
      appBar: AppBar(title: Text('${student['first_name']} ${student['last_name']}')),
      body: FutureBuilder<List<List<Json>>>(
        future: Future.wait([api.charges([id]), api.payments([id])]),
        builder: (context, snap) {
          if (snap.hasError) return ErrorView(snap.error!);
          if (!snap.hasData) return const Center(child: CircularProgressIndicator());
          final charges = snap.data![0];
          final payments = snap.data![1];
          final due = sumAmounts(charges.map((c) => '${c['remaining']}'));
          return ListView(children: [
            ListTile(title: const Text('Balance due'), trailing: Text(formatMoney(due, currency), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700))),
            const SectionHeader('Charges'),
            for (final c in charges)
              ListTile(dense: true, title: Text('${c['description']}'), subtitle: Text(c['due_date'] == null ? '' : 'Due ${formatIsoDate(c['due_date'] as String)}'), trailing: Text(formatMoney('${c['remaining']}', currency))),
            const SectionHeader('Payments'),
            for (final p in payments)
              ListTile(dense: true, title: Text(formatMoney('${p['amount']}', currency)), subtitle: Text('${formatIsoDate(p['payment_date'] as String)} · ${capitalize('${p['payment_method']}')}'), trailing: StatusChip('${p['status']}')),
          ]);
        },
      ),
    );
  }
}
