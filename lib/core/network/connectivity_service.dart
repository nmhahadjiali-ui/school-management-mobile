import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';

/// "Online" means the backend is actually reachable — a Wi-Fi icon is not
/// enough (captive portals, school networks without internet, dead hotspots).
/// The radio state from connectivity_plus triggers a reachability probe.
class ConnectivityService {
  ConnectivityService({required this.probeUrl, Connectivity? connectivity, this.probeTimeout = const Duration(seconds: 5)})
      : _connectivity = connectivity ?? Connectivity();

  final Uri probeUrl;
  final Duration probeTimeout;
  final Connectivity _connectivity;

  final _controller = StreamController<bool>.broadcast();
  StreamSubscription<List<ConnectivityResult>>? _sub;
  Timer? _retry;
  bool _online = false;
  bool _started = false;

  bool get isOnline => _online;
  Stream<bool> get onlineChanges => _controller.stream;

  Future<void> start() async {
    if (_started) return;
    _started = true;
    _sub = _connectivity.onConnectivityChanged.listen((_) => check());
    await check();
  }

  /// Re-evaluates reachability now (also used before a manual sync).
  Future<bool> check() async {
    final radios = await _connectivity.checkConnectivity();
    final hasRadio = radios.any((r) => r != ConnectivityResult.none);
    final reachable = hasRadio && await _reachable();
    _set(reachable);
    // While offline, probe periodically (radio events are not always emitted).
    _retry?.cancel();
    if (!reachable) _retry = Timer(const Duration(seconds: 30), check);
    return reachable;
  }

  Future<bool> _reachable() async {
    final client = HttpClient()..connectionTimeout = probeTimeout;
    try {
      final request = await client.getUrl(probeUrl).timeout(probeTimeout);
      final response = await request.close().timeout(probeTimeout);
      await response.drain<void>();
      return response.statusCode < 500;
    } catch (_) {
      return false;
    } finally {
      client.close(force: true);
    }
  }

  void _set(bool value) {
    if (value == _online) return;
    _online = value;
    _controller.add(value);
  }

  void dispose() {
    _sub?.cancel();
    _retry?.cancel();
    _controller.close();
  }
}
