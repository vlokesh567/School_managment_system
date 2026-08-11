import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../network/connectivity_service.dart';
import 'offline_queue.dart';
import 'sync_service.dart';

/// Expose current online/offline status reactively.
final isOnlineProvider = Provider<bool>((ref) {
  final connectivity = ref.watch(connectivityProvider);
  return connectivity.when(
    data: (status) => status == ConnectivityStatus.online,
    loading: () => true,
    error: (_, __) => true,
  );
});

/// Reactive pending queue count — uses a StateNotifier that gets
/// updated via [QueueCountNotifier] whenever the queue changes.
final pendingQueueCountProvider =
    StateNotifierProvider<QueueCountNotifier, int>((ref) {
  return QueueCountNotifier();
});

class QueueCountNotifier extends StateNotifier<int> {
  QueueCountNotifier() : super(OfflineQueue.pendingCount);

  void refresh() {
    state = OfflineQueue.pendingCount;
  }
}

/// Sync service instance provider.
final syncServiceProvider = Provider<SyncService>((ref) {
  return SyncService.instance;
});

/// Sync state for UI display.
class SyncState {
  final bool isSyncing;
  final int pendingCount;
  final String? lastSyncResult;

  const SyncState({
    this.isSyncing = false,
    this.pendingCount = 0,
    this.lastSyncResult,
  });
}

final syncStateProvider =
    StateNotifierProvider<SyncStateNotifier, SyncState>((ref) {
  return SyncStateNotifier();
});

class SyncStateNotifier extends StateNotifier<SyncState> {
  SyncStateNotifier() : super(const SyncState());

  void onSyncStarted() {
    state = SyncState(
      isSyncing: true,
      pendingCount: OfflineQueue.pendingCount,
      lastSyncResult: state.lastSyncResult,
    );
  }

  void onSyncComplete(SyncResult result) {
    state = SyncState(
      isSyncing: false,
      pendingCount: OfflineQueue.pendingCount,
      lastSyncResult:
          '${result.syncedCount} synced, ${result.failedCount} failed',
    );
  }

  void refreshPending() {
    state = SyncState(
      isSyncing: state.isSyncing,
      pendingCount: OfflineQueue.pendingCount,
      lastSyncResult: state.lastSyncResult,
    );
  }
}
