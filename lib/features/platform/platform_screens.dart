import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show PostgrestException;

import '../../core/errors/app_error.dart';
import '../../core/session/session.dart';
import '../../core/sync/remote_api.dart';
import '../../shared/ui.dart';
import 'platform_api.dart';

// Super admin screens: the web's /dashboard (platform), /platform/schools,
// /platform/schools/new, /platform/schools/[id], /platform/users and
// /platform/settings — same data, same actions, same messages. Online-only.

const roleLabels = {
  'super_admin': 'Platform Admin',
  'school_admin': 'School Admin',
  'finance_admin': 'Finance Admin',
  'finance_staff': 'Finance Staff',
  'teacher': 'Teacher',
  'student': 'Student',
  'parent': 'Parent',
};

/// Roles a super admin may give a new account (the web's PROVISIONABLE_ROLES).
const provisionableRoles = ['school_admin', 'finance_admin', 'finance_staff', 'teacher', 'student', 'parent'];

void _toast(BuildContext context, String message) =>
    ScaffoldMessenger.of(context)..hideCurrentSnackBar()..showSnackBar(SnackBar(content: Text(message)));

void _toastError(BuildContext context, Object e) => _toast(context, toAppError(e).message);

Future<bool> _confirm(BuildContext context, {required String title, required String message, required String action, bool destructive = false}) async =>
    await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('Cancel')),
          FilledButton(
            style: destructive ? FilledButton.styleFrom(backgroundColor: Theme.of(c).colorScheme.error) : null,
            onPressed: () => Navigator.pop(c, true),
            child: Text(action),
          ),
        ],
      ),
    ) ==
    true;

/// Loading / error (with retry) / data, for online-only screens.
Widget _load<T>(AsyncValue<T> value, VoidCallback retry, Widget Function(T data) builder) => value.when(
      data: builder,
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) {
        final err = toAppError(e);
        return ListView(children: [
          const SizedBox(height: 80),
          EmptyView(
            title: err.isOffline ? "You're offline" : 'Could not load',
            message: err.isOffline ? 'Platform administration needs an internet connection.' : err.message,
            icon: err.isOffline ? Icons.cloud_off : Icons.error_outline,
          ),
          Center(child: TextButton.icon(onPressed: retry, icon: const Icon(Icons.refresh), label: const Text('Try again'))),
        ]);
      },
    );

String _currentProfileId(WidgetRef ref) => ((ref.read(userContextProvider).value?.raw['profile'] as Map?)?['id'] as String?) ?? '';

// --- Dashboard ---------------------------------------------------------------

/// Home for the super admin: the web's platform dashboard.
class PlatformDashboard extends ConsumerWidget {
  const PlatformDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(platformStatsProvider);
    final schools = ref.watch(platformSchoolsProvider);
    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(platformStatsProvider);
        ref.invalidate(platformSchoolsProvider);
        await ref.read(platformSchoolsProvider.future).catchError((_) => <Json>[]);
      },
      child: _load(stats, () => ref.invalidate(platformStatsProvider), (s) {
        return ListView(padding: const EdgeInsets.only(bottom: 24), children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
            child: Text('Platform dashboard', style: Theme.of(context).textTheme.headlineSmall),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text('Platform-wide overview across every school on this installation.', style: TextStyle(color: Colors.grey)),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Wrap(spacing: 8, runSpacing: 8, children: [
              StatTile('Total schools', '${s['totalSchools']}'),
              StatTile('Active schools', '${s['activeSchools']}'),
              StatTile('Inactive schools', '${s['inactiveSchools']}'),
              StatTile('Total users', '${s['totalUsers']}', hint: 'All accounts, all schools'),
            ]),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: FilledButton.icon(onPressed: () => context.push('/platform/schools/new'), icon: const Icon(Icons.add), label: const Text('New school')),
          ),
          SectionHeader('Schools', trailing: TextButton(onPressed: () => context.go('/main'), child: const Text('Manage schools'))),
          ...schools.when(
            data: (rows) => rows.isEmpty
                ? [const ListTile(title: Text('No schools yet.'))]
                : [for (final school in rows.take(10)) SchoolTile(school)],
            loading: () => [const LinearProgressIndicator()],
            error: (e, _) => [ListTile(leading: const Icon(Icons.error_outline), title: Text(toAppError(e).message))],
          ),
        ]);
      }),
    );
  }
}

class StatTile extends StatelessWidget {
  const StatTile(this.label, this.value, {super.key, this.hint});
  final String label;
  final String value;
  final String? hint;

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
              Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
              if (hint != null) Text(hint!, style: const TextStyle(fontSize: 11, color: Colors.grey)),
            ]),
          ),
        ),
      );
}

// --- Schools -------------------------------------------------------------------

class SchoolTile extends StatelessWidget {
  const SchoolTile(this.school, {super.key});
  final Json school;

  @override
  Widget build(BuildContext context) {
    final logo = school['logo_url'] as String?;
    final name = school['name'] as String? ?? '';
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: logo != null ? NetworkImage(logo) : null,
        child: logo == null ? Text(name.isEmpty ? '?' : name[0].toUpperCase()) : null,
      ),
      title: Text(name),
      subtitle: Text('${school['code']} · ${school['user_count']} user${school['user_count'] == 1 ? '' : 's'} · created ${formatDate(DateTime.tryParse('${school['created_at']}'))}'),
      trailing: StatusChip('${school['status']}'),
      onTap: () => context.push('/platform/schools/${school['id']}'),
    );
  }
}

class SchoolsScreen extends ConsumerStatefulWidget {
  const SchoolsScreen({super.key});

  @override
  ConsumerState<SchoolsScreen> createState() => _SchoolsScreenState();
}

class _SchoolsScreenState extends ConsumerState<SchoolsScreen> {
  String _q = '';

  @override
  Widget build(BuildContext context) {
    final schools = ref.watch(platformSchoolsProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Schools')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/platform/schools/new'),
        icon: const Icon(Icons.add),
        label: const Text('New school'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(platformSchoolsProvider);
          await ref.read(platformSchoolsProvider.future).catchError((_) => <Json>[]);
        },
        child: _load(schools, () => ref.invalidate(platformSchoolsProvider), (rows) {
          final q = _q.toLowerCase();
          final shown = q.isEmpty ? rows : rows.where((s) => '${s['name']} ${s['code']}'.toLowerCase().contains(q)).toList();
          return ListView(padding: const EdgeInsets.only(bottom: 88), children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
              child: Text('Every school on the platform (${rows.length}).', style: const TextStyle(color: Colors.grey)),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
              child: TextField(
                decoration: const InputDecoration(labelText: 'Search by name or code', border: OutlineInputBorder(), prefixIcon: Icon(Icons.search), isDense: true),
                onChanged: (v) => setState(() => _q = v.trim()),
              ),
            ),
            if (shown.isEmpty) const ListTile(title: Text('No schools found.')),
            for (final s in shown) SchoolTile(s),
          ]);
        }),
      ),
    );
  }
}

// --- School form (create / edit) ------------------------------------------------

final _emailRe = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
final _codeRe = RegExp(r'^[A-Z0-9][A-Z0-9-]{1,19}$');

/// Fields and rules of the web's SchoolForm (code and initial status only on create).
class SchoolForm extends ConsumerStatefulWidget {
  const SchoolForm({super.key, this.school});
  final Json? school;

  @override
  ConsumerState<SchoolForm> createState() => _SchoolFormState();
}

class _SchoolFormState extends ConsumerState<SchoolForm> {
  final _form = GlobalKey<FormState>();
  late final _name = TextEditingController(text: widget.school?['name'] as String?);
  final _code = TextEditingController();
  late final _email = TextEditingController(text: widget.school?['contact_email'] as String?);
  late final _phone = TextEditingController(text: widget.school?['contact_phone'] as String?);
  late final _address = TextEditingController(text: widget.school?['address'] as String?);
  late final _tz = TextEditingController(text: widget.school?['timezone'] as String? ?? 'Asia/Manila');
  String _status = 'active';
  bool _busy = false;
  String? _codeError;

  bool get _create => widget.school == null;

  @override
  void dispose() {
    for (final c in [_name, _code, _email, _phone, _address, _tz]) {
      c.dispose();
    }
    super.dispose();
  }

  String? _nullIfEmpty(String v) => v.trim().isEmpty ? null : v.trim();

  Future<void> _save() async {
    setState(() => _codeError = null);
    if (!_form.currentState!.validate()) return;
    final values = <String, dynamic>{
      'name': _name.text.trim(),
      'address': _nullIfEmpty(_address.text),
      'contact_email': _nullIfEmpty(_email.text)?.toLowerCase(),
      'contact_phone': _nullIfEmpty(_phone.text),
      'timezone': _tz.text.trim(),
    };
    setState(() => _busy = true);
    final api = ref.read(platformApiProvider);
    try {
      if (_create) {
        final id = await api.createSchool({...values, 'code': _code.text.trim().toUpperCase(), 'status': _status});
        ref.invalidate(platformSchoolsProvider);
        ref.invalidate(platformStatsProvider);
        if (!mounted) return;
        _toast(context, 'School created. Next, add a school administrator below.');
        context.pushReplacement('/platform/schools/$id');
      } else {
        final id = widget.school!['id'] as String;
        await api.updateSchool(id, values);
        ref.invalidate(platformSchoolProvider(id));
        ref.invalidate(platformSchoolsProvider);
        if (mounted) _toast(context, 'School details saved.');
      }
    } catch (e) {
      final err = toAppError(e);
      final cause = err.cause;
      final duplicate = cause is PostgrestException && cause.code == '23505';
      if (_create && duplicate) {
        setState(() => _codeError = 'This code is already in use');
      } else if (mounted) {
        _toastError(context, e);
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    InputDecoration deco(String label, {String? hint}) => InputDecoration(labelText: label, helperText: hint, helperMaxLines: 2, border: const OutlineInputBorder());
    const gap = SizedBox(height: 12);
    return Form(
      key: _form,
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        TextFormField(
          controller: _name,
          decoration: deco('School name'),
          textCapitalization: TextCapitalization.words,
          validator: (v) {
            final t = v?.trim() ?? '';
            if (t.length < 2) return 'School name is required';
            return t.length > 200 ? 'Use at most 200 characters' : null;
          },
        ),
        gap,
        if (_create)
          TextFormField(
            controller: _code,
            decoration: deco('School code', hint: '2–20 letters, numbers or dashes. Users enter this to join.').copyWith(errorText: _codeError),
            textCapitalization: TextCapitalization.characters,
            validator: (v) => _codeRe.hasMatch((v ?? '').trim().toUpperCase()) ? null : '2–20 letters, numbers or dashes',
          )
        else
          TextFormField(initialValue: '${widget.school!['code']}', enabled: false, decoration: deco('School code', hint: 'The code cannot be changed.')),
        gap,
        TextFormField(
          controller: _email,
          decoration: deco('Contact email'),
          keyboardType: TextInputType.emailAddress,
          validator: (v) => (v ?? '').trim().isEmpty || _emailRe.hasMatch(v!.trim()) ? null : 'Enter a valid email address',
        ),
        gap,
        TextFormField(
          controller: _phone,
          decoration: deco('Contact phone'),
          keyboardType: TextInputType.phone,
          validator: (v) => (v ?? '').trim().length > 40 ? 'Use at most 40 characters' : null,
        ),
        gap,
        TextFormField(
          controller: _address,
          decoration: deco('Address'),
          maxLines: 3,
          minLines: 2,
          validator: (v) => (v ?? '').length > 500 ? 'Use at most 500 characters' : null,
        ),
        gap,
        TextFormField(
          controller: _tz,
          decoration: deco('Time zone', hint: 'IANA name, e.g. Asia/Manila'),
          validator: (v) => (v ?? '').trim().isEmpty ? 'Choose a valid time zone' : null,
        ),
        if (_create) ...[
          gap,
          DropdownButtonFormField<String>(
            initialValue: _status,
            decoration: deco('Initial status'),
            items: const [DropdownMenuItem(value: 'active', child: Text('Active')), DropdownMenuItem(value: 'inactive', child: Text('Inactive'))],
            onChanged: (v) => setState(() => _status = v ?? 'active'),
          ),
        ],
        const SizedBox(height: 16),
        FilledButton(
          onPressed: _busy ? null : _save,
          child: _busy ? const SizedBox.square(dimension: 18, child: CircularProgressIndicator(strokeWidth: 2)) : Text(_create ? 'Create school' : 'Save changes'),
        ),
      ]),
    );
  }
}

class NewSchoolScreen extends StatelessWidget {
  const NewSchoolScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('New school')),
        body: ListView(padding: const EdgeInsets.all(16), children: const [
          Text('Default settings and feature flags (all off) are created automatically.', style: TextStyle(color: Colors.grey)),
          SizedBox(height: 16),
          SchoolForm(),
        ]),
      );
}

// --- School detail ------------------------------------------------------------------

class SchoolDetailScreen extends ConsumerWidget {
  const SchoolDetailScreen({super.key, required this.schoolId});
  final String schoolId;

  Future<void> _setStatus(BuildContext context, WidgetRef ref, Json s) async {
    final activate = s['status'] != 'active';
    final ok = await _confirm(
      context,
      title: '${activate ? 'Activate' : 'Deactivate'} ${s['name']}?',
      message: activate
          ? 'Active users of this school will be able to sign in again.'
          : 'All users of this school will immediately lose access. No data is deleted, and you can reactivate the school at any time.',
      action: activate ? 'Activate' : 'Deactivate',
      destructive: !activate,
    );
    if (!ok || !context.mounted) return;
    try {
      await ref.read(platformApiProvider).updateSchool(schoolId, {'status': activate ? 'active' : 'inactive'});
      ref.invalidate(platformSchoolProvider(schoolId));
      ref.invalidate(platformSchoolsProvider);
      ref.invalidate(platformStatsProvider);
      if (context.mounted) _toast(context, activate ? 'School activated.' : 'School deactivated.');
    } catch (e) {
      if (context.mounted) _toastError(context, e);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final school = ref.watch(platformSchoolProvider(schoolId));
    return Scaffold(
      appBar: AppBar(title: Text(school.value?['name'] as String? ?? 'School')),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(platformSchoolProvider(schoolId));
          ref.invalidate(platformSchoolFeaturesProvider(schoolId));
          ref.invalidate(platformUsersProvider(schoolId));
          await ref.read(platformSchoolProvider(schoolId).future).catchError((_) => null);
        },
        child: _load(school, () => ref.invalidate(platformSchoolProvider(schoolId)), (s) {
          if (s == null) {
            return ListView(children: const [
              SizedBox(height: 80),
              EmptyView(title: 'Not found', message: 'The school was not found or you do not have access to it.', icon: Icons.search_off),
            ]);
          }
          final active = s['status'] == 'active';
          return ListView(padding: const EdgeInsets.only(bottom: 32), children: [
            ListTile(
              title: Text('Platform · ${s['code']}', style: const TextStyle(color: Colors.grey, fontSize: 13)),
              subtitle: Padding(padding: const EdgeInsets.only(top: 4), child: Align(alignment: Alignment.centerLeft, child: StatusChip('${s['status']}'))),
              trailing: active
                  ? OutlinedButton(
                      style: OutlinedButton.styleFrom(foregroundColor: Theme.of(context).colorScheme.error),
                      onPressed: () => _setStatus(context, ref, s),
                      child: const Text('Deactivate school'),
                    )
                  : FilledButton(onPressed: () => _setStatus(context, ref, s), child: const Text('Activate school')),
            ),
            _Card(title: 'Logo', child: _LogoEditor(school: s)),
            _Card(title: 'Details', child: SchoolForm(key: ValueKey('${s['id']}${s['name']}${s['timezone']}'), school: s)),
            _Card(
              title: 'Add user',
              subtitle: 'Create an account in this school, e.g. its first school administrator.',
              child: Align(
                alignment: Alignment.centerLeft,
                child: FilledButton.icon(
                  onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => ProvisionUserScreen(schoolId: schoolId, schoolName: '${s['name']}'))),
                  icon: const Icon(Icons.person_add_alt),
                  label: const Text('Add user'),
                ),
              ),
            ),
            _Card(title: 'Features', subtitle: 'Optional modules for this school.', padded: false, child: _FeatureToggles(schoolId: schoolId)),
            _SchoolUsers(schoolId: schoolId),
          ]);
        }),
      ),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.title, this.subtitle, required this.child, this.padded = true});
  final String title;
  final String? subtitle;
  final Widget child;
  final bool padded;

  @override
  Widget build(BuildContext context) => Card(
        margin: const EdgeInsets.fromLTRB(12, 12, 12, 0),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: padded ? 16 : 0),
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: padded ? 0 : 16),
              child: Text(title, style: Theme.of(context).textTheme.titleMedium),
            ),
            if (subtitle != null)
              Padding(
                padding: EdgeInsets.fromLTRB(padded ? 0 : 16, 2, padded ? 0 : 16, 0),
                child: Text(subtitle!, style: const TextStyle(color: Colors.grey, fontSize: 13)),
              ),
            const SizedBox(height: 12),
            child,
          ]),
        ),
      );
}

class _LogoEditor extends ConsumerStatefulWidget {
  const _LogoEditor({required this.school});
  final Json school;

  @override
  ConsumerState<_LogoEditor> createState() => _LogoEditorState();
}

class _LogoEditorState extends ConsumerState<_LogoEditor> {
  bool _busy = false;

  static const _maxBytes = 1.5 * 1024 * 1024;

  Future<void> _change({required bool remove}) async {
    final id = widget.school['id'] as String;
    final api = ref.read(platformApiProvider);
    try {
      if (remove) {
        setState(() => _busy = true);
        await api.setLogo(id, oldUrl: widget.school['logo_url'] as String?);
      } else {
        final file = await ImagePicker().pickImage(source: ImageSource.gallery, maxWidth: 1024, maxHeight: 1024, imageQuality: 85);
        if (file == null) return;
        final name = file.name.toLowerCase();
        final ext = name.endsWith('.png') ? 'png' : name.endsWith('.webp') ? 'webp' : (name.endsWith('.jpg') || name.endsWith('.jpeg')) ? 'jpg' : null;
        if (!mounted) return;
        if (ext == null) return _toast(context, 'Use a JPG, PNG or WebP picture.');
        final bytes = await file.readAsBytes();
        if (!mounted) return;
        if (bytes.length > _maxBytes) return _toast(context, 'The picture is ${(bytes.length / 1024 / 1024).toStringAsFixed(1)} MB. The maximum is 1.5 MB.');
        setState(() => _busy = true);
        await api.setLogo(id, bytes: bytes, ext: ext, oldUrl: widget.school['logo_url'] as String?);
      }
      ref.invalidate(platformSchoolProvider(id));
      ref.invalidate(platformSchoolsProvider);
      if (mounted) _toast(context, remove ? 'Logo removed.' : 'Logo updated.');
    } catch (e) {
      if (mounted) _toastError(context, e);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final url = widget.school['logo_url'] as String?;
    return Row(children: [
      Container(
        width: 72,
        height: 72,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.black12)),
        clipBehavior: Clip.antiAlias,
        child: url == null ? const Icon(Icons.image_outlined, color: Colors.grey) : Image.network(url, fit: BoxFit.contain, errorBuilder: (_, _, _) => const Icon(Icons.broken_image_outlined)),
      ),
      const SizedBox(width: 16),
      Expanded(
        child: Wrap(spacing: 8, runSpacing: 8, crossAxisAlignment: WrapCrossAlignment.center, children: [
          if (_busy) const SizedBox.square(dimension: 20, child: CircularProgressIndicator(strokeWidth: 2)),
          OutlinedButton(onPressed: _busy ? null : () => _change(remove: false), child: Text(url == null ? 'Upload logo' : 'Change')),
          if (url != null) TextButton(onPressed: _busy ? null : () => _change(remove: true), child: const Text('Remove')),
          const Text('JPG, PNG or WebP, up to 1.5 MB.', style: TextStyle(color: Colors.grey, fontSize: 12)),
        ]),
      ),
    ]);
  }
}

class _FeatureToggles extends ConsumerStatefulWidget {
  const _FeatureToggles({required this.schoolId});
  final String schoolId;

  @override
  ConsumerState<_FeatureToggles> createState() => _FeatureTogglesState();
}

class _FeatureTogglesState extends ConsumerState<_FeatureToggles> {
  final _busy = <String>{};

  Future<void> _toggle(String key, bool enabled) async {
    setState(() => _busy.add(key));
    try {
      await ref.read(platformApiProvider).setFeature(widget.schoolId, key, enabled);
      ref.invalidate(platformSchoolFeaturesProvider(widget.schoolId));
      await ref.read(platformSchoolFeaturesProvider(widget.schoolId).future);
      if (mounted) _toast(context, enabled ? 'Feature enabled.' : 'Feature disabled.');
    } catch (e) {
      if (mounted) _toastError(context, e);
    } finally {
      if (mounted) setState(() => _busy.remove(key));
    }
  }

  @override
  Widget build(BuildContext context) {
    final features = ref.watch(platformSchoolFeaturesProvider(widget.schoolId));
    return features.when(
      loading: () => const Padding(padding: EdgeInsets.all(16), child: LinearProgressIndicator()),
      error: (e, _) => ListTile(leading: const Icon(Icons.error_outline), title: Text(toAppError(e).message)),
      data: (rows) => Column(children: [
        for (final f in rows)
          SwitchListTile(
            title: Text('${f['name']}'),
            subtitle: f['description'] == null ? null : Text('${f['description']}', style: const TextStyle(fontSize: 12)),
            value: f['enabled'] == true,
            onChanged: _busy.contains(f['key']) ? null : (v) => _toggle('${f['key']}', v),
          ),
      ]),
    );
  }
}

class _SchoolUsers extends ConsumerWidget {
  const _SchoolUsers({required this.schoolId});
  final String schoolId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final users = ref.watch(platformUsersProvider(schoolId));
    final count = users.value?.length;
    return _Card(
      title: 'Users',
      subtitle: count == null ? null : '$count account(s)',
      padded: false,
      child: users.when(
        loading: () => const Padding(padding: EdgeInsets.all(16), child: LinearProgressIndicator()),
        error: (e, _) => ListTile(leading: const Icon(Icons.error_outline), title: Text(toAppError(e).message)),
        data: (rows) => rows.isEmpty
            ? const ListTile(title: Text('No users found'), subtitle: Text('Users will appear here once they register or are added.'))
            : Column(children: [for (final u in rows) UserTile(user: u, showSchool: false, schoolId: schoolId)]),
      ),
    );
  }
}

// --- Users ------------------------------------------------------------------------

/// One account with the web's platform actions: approve, deactivate, reactivate.
/// Never offered for yourself or for other super admins (the database refuses too).
class UserTile extends ConsumerStatefulWidget {
  const UserTile({super.key, required this.user, required this.showSchool, this.schoolId});
  final Json user;
  final bool showSchool;

  /// The list this tile belongs to (null = all users), to refresh after a change.
  final String? schoolId;

  @override
  ConsumerState<UserTile> createState() => _UserTileState();
}

class _UserTileState extends ConsumerState<UserTile> {
  bool _busy = false;

  String get _name {
    final n = '${widget.user['first_name'] ?? ''} ${widget.user['last_name'] ?? ''}'.trim();
    return n.isEmpty ? '${widget.user['email']}' : n;
  }

  Future<void> _set(String status) async {
    if (status == 'inactive') {
      final ok = await _confirm(context,
          title: 'Deactivate $_name?',
          message: 'They will lose access immediately. You can reactivate the account later.',
          action: 'Deactivate',
          destructive: true);
      if (!ok) return;
    }
    setState(() => _busy = true);
    try {
      await ref.read(platformApiProvider).setUserStatus('${widget.user['id']}', status);
      ref.invalidate(platformUsersProvider(widget.schoolId));
      ref.invalidate(platformUsersProvider(widget.user['school_id'] as String?));
      ref.invalidate(platformUsersProvider(null));
      if (mounted) _toast(context, 'User updated.');
    } catch (e) {
      if (mounted) _toastError(context, e);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final u = widget.user;
    final status = '${u['status']}';
    final canManage = u['id'] != _currentProfileId(ref) && u['role'] != 'super_admin';
    final school = (u['school'] as Map?)?['name'] as String?;
    final parts = [
      '${u['email']}',
      [roleLabels[u['role']] ?? capitalize('${u['role']}'), if (widget.showSchool) school ?? 'Platform'].join(' · '),
      'Joined ${formatDate(DateTime.tryParse('${u['created_at']}'))}',
    ];
    return ListTile(
      isThreeLine: true,
      title: Row(children: [Expanded(child: Text(_name, overflow: TextOverflow.ellipsis)), const SizedBox(width: 8), StatusChip(status)]),
      subtitle: Text(parts.join('\n')),
      trailing: !canManage
          ? null
          : _busy
              ? const SizedBox.square(dimension: 20, child: CircularProgressIndicator(strokeWidth: 2))
              : PopupMenuButton<String>(
                  tooltip: 'Actions',
                  onSelected: _set,
                  itemBuilder: (_) => [
                    if (status == 'pending') const PopupMenuItem(value: 'active', child: Text('Approve')),
                    if (status == 'active') const PopupMenuItem(value: 'inactive', child: Text('Deactivate')),
                    if (status == 'inactive') const PopupMenuItem(value: 'active', child: Text('Reactivate')),
                  ],
                ),
    );
  }
}

class PlatformUsersScreen extends ConsumerStatefulWidget {
  const PlatformUsersScreen({super.key});

  @override
  ConsumerState<PlatformUsersScreen> createState() => _PlatformUsersScreenState();
}

class _PlatformUsersScreenState extends ConsumerState<PlatformUsersScreen> {
  String _q = '';
  String? _role;
  String? _status;

  @override
  Widget build(BuildContext context) {
    final users = ref.watch(platformUsersProvider(null));
    return Scaffold(
      appBar: AppBar(title: const Text('Users')),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(platformUsersProvider(null));
          await ref.read(platformUsersProvider(null).future).catchError((_) => <Json>[]);
        },
        child: _load(users, () => ref.invalidate(platformUsersProvider(null)), (rows) {
          final q = _q.toLowerCase();
          final shown = rows.where((u) {
            if (_role != null && u['role'] != _role) return false;
            if (_status != null && u['status'] != _status) return false;
            if (q.isEmpty) return true;
            return '${u['first_name']} ${u['last_name']} ${u['email']} ${(u['school'] as Map?)?['name'] ?? ''}'.toLowerCase().contains(q);
          }).toList();
          return ListView(padding: const EdgeInsets.only(bottom: 24), children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 8, 16, 4),
              child: Text('Accounts across all schools (latest 500).', style: TextStyle(color: Colors.grey)),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
              child: TextField(
                decoration: const InputDecoration(labelText: 'Search name, email or school', border: OutlineInputBorder(), prefixIcon: Icon(Icons.search), isDense: true),
                onChanged: (v) => setState(() => _q = v.trim()),
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(children: [
                for (final s in ['pending', 'active', 'inactive'])
                  Padding(
                    padding: const EdgeInsets.all(4),
                    child: FilterChip(label: Text(capitalize(s)), selected: _status == s, onSelected: (on) => setState(() => _status = on ? s : null)),
                  ),
                const SizedBox(width: 8),
                for (final r in roleLabels.keys)
                  Padding(
                    padding: const EdgeInsets.all(4),
                    child: FilterChip(label: Text(roleLabels[r]!), selected: _role == r, onSelected: (on) => setState(() => _role = on ? r : null)),
                  ),
              ]),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
              child: Text('${shown.length} shown', style: const TextStyle(color: Colors.grey, fontSize: 12)),
            ),
            if (shown.isEmpty) const ListTile(title: Text('No users found')),
            for (final u in shown) UserTile(key: ValueKey(u['id']), user: u, showSchool: true),
          ]);
        }),
      ),
    );
  }
}

// --- Add user ---------------------------------------------------------------------

class ProvisionUserScreen extends ConsumerStatefulWidget {
  const ProvisionUserScreen({super.key, required this.schoolId, required this.schoolName});
  final String schoolId;
  final String schoolName;

  @override
  ConsumerState<ProvisionUserScreen> createState() => _ProvisionUserScreenState();
}

class _ProvisionUserScreenState extends ConsumerState<ProvisionUserScreen> {
  final _form = GlobalKey<FormState>();
  final _first = TextEditingController();
  final _last = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  String? _role;
  bool _busy = false;
  bool _show = false;
  String? _error;
  Map<String, String> _fieldErrors = const {};

  @override
  void dispose() {
    for (final c in [_first, _last, _email, _password]) {
      c.dispose();
    }
    super.dispose();
  }

  String? _password8(String? v) {
    final p = v ?? '';
    if (p.length < 8) return 'Use at least 8 characters';
    if (p.length > 72) return 'Use at most 72 characters';
    if (!RegExp('[A-Za-z]').hasMatch(p)) return 'Include at least one letter';
    if (!RegExp('[0-9]').hasMatch(p)) return 'Include at least one number';
    return null;
  }

  Future<void> _submit() async {
    setState(() {
      _error = null;
      _fieldErrors = const {};
    });
    if (!_form.currentState!.validate()) return;
    setState(() => _busy = true);
    try {
      final result = await ref.read(platformApiProvider).provisionUser(widget.schoolId, {
        'first_name': _first.text.trim(),
        'last_name': _last.text.trim(),
        'email': _email.text.trim().toLowerCase(),
        'role': _role,
        'password': _password.text,
      });
      if (!mounted) return;
      if (result == null) {
        ref.invalidate(platformUsersProvider(widget.schoolId));
        ref.invalidate(platformUsersProvider(null));
        ref.invalidate(platformSchoolsProvider);
        ref.invalidate(platformStatsProvider);
        _toast(context, 'Account created. Share the temporary password securely; the user can change it after signing in.');
        Navigator.of(context).pop();
        return;
      }
      setState(() {
        _error = '${result['error']}';
        _fieldErrors = {
          for (final e in ((result['fieldErrors'] as Map?) ?? const {}).entries) '${e.key}': ((e.value as List?)?.firstOrNull ?? '').toString(),
        };
      });
    } catch (e) {
      if (mounted) setState(() => _error = toAppError(e).message);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    InputDecoration deco(String label, String field, {String? hint, Widget? suffix}) =>
        InputDecoration(labelText: label, helperText: hint, helperMaxLines: 2, errorText: _fieldErrors[field], suffixIcon: suffix, border: const OutlineInputBorder());
    String? required(String? v, String label) => (v ?? '').trim().isEmpty ? '$label is required' : ((v!.trim().length > 100) ? 'Use at most 100 characters' : null);
    const gap = SizedBox(height: 12);
    return Scaffold(
      appBar: AppBar(title: const Text('Add user')),
      body: Form(
        key: _form,
        child: ListView(padding: const EdgeInsets.all(16), children: [
          Text('Create an account in ${widget.schoolName}.', style: const TextStyle(color: Colors.grey)),
          gap,
          if (_error != null)
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(color: Theme.of(context).colorScheme.errorContainer, borderRadius: BorderRadius.circular(8)),
              child: Text(_error!, style: TextStyle(color: Theme.of(context).colorScheme.onErrorContainer)),
            ),
          TextFormField(controller: _first, decoration: deco('First name', 'first_name'), textCapitalization: TextCapitalization.words, validator: (v) => required(v, 'First name')),
          gap,
          TextFormField(controller: _last, decoration: deco('Last name', 'last_name'), textCapitalization: TextCapitalization.words, validator: (v) => required(v, 'Last name')),
          gap,
          TextFormField(
            controller: _email,
            decoration: deco('Email', 'email'),
            keyboardType: TextInputType.emailAddress,
            autocorrect: false,
            validator: (v) => _emailRe.hasMatch((v ?? '').trim()) ? null : 'Enter a valid email address',
          ),
          gap,
          DropdownButtonFormField<String>(
            initialValue: _role,
            decoration: deco('Role', 'role'),
            items: [for (final r in provisionableRoles) DropdownMenuItem(value: r, child: Text(roleLabels[r]!))],
            onChanged: (v) => setState(() => _role = v),
            validator: (v) => v == null ? 'Choose a role' : null,
          ),
          gap,
          TextFormField(
            controller: _password,
            obscureText: !_show,
            autocorrect: false,
            decoration: deco('Temporary password', 'password',
                hint: 'At least 8 characters, with a letter and a number.',
                suffix: IconButton(icon: Icon(_show ? Icons.visibility_off : Icons.visibility), onPressed: () => setState(() => _show = !_show))),
            validator: _password8,
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: _busy ? null : _submit,
            child: _busy ? const SizedBox.square(dimension: 18, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('Create account'),
          ),
        ]),
      ),
    );
  }
}

// --- Platform settings ------------------------------------------------------------------

class PlatformSettingsScreen extends ConsumerWidget {
  const PlatformSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final catalog = ref.watch(featureCatalogProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Platform settings')),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(featureCatalogProvider);
          await ref.read(featureCatalogProvider.future).catchError((_) => <Json>[]);
        },
        child: _load(catalog, () => ref.invalidate(featureCatalogProvider), (rows) => ListView(children: [
              const ListTile(
                title: Text('Feature catalog'),
                subtitle: Text(
                    "Optional modules available to schools. Enable them per school from each school's page. New features are added through database migrations."),
              ),
              const Divider(),
              for (final f in rows)
                ListTile(
                  title: Text('${f['name']}'),
                  subtitle: Text([if (f['description'] != null) '${f['description']}', '${f['key']}'].join('\n')),
                  isThreeLine: f['description'] != null,
                ),
            ])),
      ),
    );
  }
}
