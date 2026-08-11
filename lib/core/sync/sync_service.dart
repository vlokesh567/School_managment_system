import 'dart:async';
import 'package:flutter/foundation.dart';
import '../network/connectivity_service.dart';
import 'offline_queue.dart';
import 'sync_provider.dart';

/// Maximum retries before a mutation is dropped.
const int _maxRetries = 5;

/// Result of a single sync attempt.
class SyncResult {
  final int syncedCount;
  final int failedCount;
  final int skippedCount;

  SyncResult({
    this.syncedCount = 0,
    this.failedCount = 0,
    this.skippedCount = 0,
  });

  bool get allSynced => failedCount == 0 && skippedCount == 0;
}

/// Callback type for processing a single mutation.
/// Return `true` if the mutation was processed successfully.
typedef MutationProcessor = Future<bool> Function(QueuedMutation mutation);

/// Service that watches connectivity and automatically processes
/// any queued offline mutations when the device comes back online.
///
/// Also exposes a manual [syncNow] method.
class SyncService {
  static SyncService? _instance;
  StreamSubscription<ConnectivityStatus>? _subscription;

  /// Map of feature → processor function.
  final Map<String, MutationProcessor> _processors = {};

  bool _isSyncing = false;
  SyncStateNotifier? _stateNotifier;
  QueueCountNotifier? _countNotifier;

  SyncService._();

  static SyncService get instance {
    _instance ??= SyncService._();
    return _instance!;
  }

  /// Wire up the notifiers for UI reactivity.
  void attachNotifiers(SyncStateNotifier? stateNotifier, QueueCountNotifier? countNotifier) {
    _stateNotifier = stateNotifier;
    _countNotifier = countNotifier;
  }

  /// Register a processor for a specific feature.
  void registerProcessor(String feature, MutationProcessor processor) {
    _processors[feature] = processor;
  }

  /// Start listening for connectivity changes.
  void start() {
    _subscription?.cancel();
    _subscription =
        ConnectivityService.instance.statusStream.listen((status) {
      if (status == ConnectivityStatus.online) {
        syncNow();
      }
    });
  }

  /// Manually trigger sync of all pending mutations.
  Future<SyncResult> syncNow() async {
    if (_isSyncing) return SyncResult();
    _isSyncing = true;
    _stateNotifier?.onSyncStarted();

    try {
      final mutations = OfflineQueue.peekAll();
      if (mutations.isEmpty) {
        _stateNotifier?.onSyncComplete(SyncResult());
        return SyncResult();
      }

      int synced = 0;
      int failed = 0;
      int skipped = 0;

      for (final mutation in mutations) {
        if (mutation.retryCount >= _maxRetries) {
          debugPrint('[Sync] Dropping mutation ${mutation.id} after $_maxRetries retries');
          await OfflineQueue.remove(mutation.id);
          skipped++;
          continue;
        }

        final processor = _processors[mutation.feature];
        if (processor == null) {
          debugPrint('[Sync] No processor registered for feature: ${mutation.feature}');
          skipped++;
          continue;
        }

        try {
          final success = await processor(mutation);
          if (success) {
            await OfflineQueue.remove(mutation.id);
            synced++;
            debugPrint('[Sync] Synced ${mutation.id} (${mutation.action})');
          } else {
            await OfflineQueue.incrementRetry(mutation.id);
            failed++;
            debugPrint('[Sync] Failed to sync ${mutation.id}');
          }
        } catch (e) {
          await OfflineQueue.incrementRetry(mutation.id);
          failed++;
          debugPrint('[Sync] Error syncing ${mutation.id}: $e');
        }
      }

      final result = SyncResult(
        syncedCount: synced,
        failedCount: failed,
        skippedCount: skipped,
      );
      _stateNotifier?.onSyncComplete(result);
      _countNotifier?.refresh();
      return result;
    } finally {
      _isSyncing = false;
    }
  }

  /// Stop listening.
  void dispose() {
    _subscription?.cancel();
  }
}
