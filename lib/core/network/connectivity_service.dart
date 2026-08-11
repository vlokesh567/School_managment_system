import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Tracks the current online/offline state.
enum ConnectivityStatus { online, offline }

/// Riverpod provider — read or watch for reactive connectivity.
final connectivityProvider =
    StreamProvider<ConnectivityStatus>((ref) {
  return ConnectivityService.instance.statusStream;
});

/// Singleton service that monitors network connectivity via [connectivity_plus].
///
/// Call [start] once at app startup.
class ConnectivityService {
  static ConnectivityService? _instance;
  final Connectivity _connectivity = Connectivity();
  final StreamController<ConnectivityStatus> _controller =
      StreamController<ConnectivityStatus>.broadcast();

  ConnectivityStatus _currentStatus = ConnectivityStatus.online;

  ConnectivityService._();

  static ConnectivityService get instance {
    _instance ??= ConnectivityService._();
    return _instance!;
  }

  /// Current connectivity status (synchronous access).
  ConnectivityStatus get currentStatus => _currentStatus;

  /// Stream of status changes — fires on every connectivity change.
  Stream<ConnectivityStatus> get statusStream => _controller.stream;

  /// Start listening to connectivity changes. Call once at startup.
  Future<void> start() async {
    // Initial check
    final results = await _connectivity.checkConnectivity();
    _updateStatus(results);

    // Listen for changes
    _connectivity.onConnectivityChanged.listen(_updateStatus);
  }

  void _updateStatus(List<ConnectivityResult> results) {
    final online = results.any((r) =>
        r == ConnectivityResult.wifi ||
        r == ConnectivityResult.mobile ||
        r == ConnectivityResult.ethernet);
    _currentStatus =
        online ? ConnectivityStatus.online : ConnectivityStatus.offline;
    _controller.add(_currentStatus);
  }

  /// Quick synchronous check.
  bool get isOnline => _currentStatus == ConnectivityStatus.online;

  /// Dispose.
  void dispose() {
    _controller.close();
  }
}
