import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/notification_repository.dart';
import '../models/notification_model.dart';

final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  return NotificationRepository();
});

class NotificationListNotifier extends StateNotifier<AsyncValue<List<NotificationModel>>> {
  final NotificationRepository _repo;

  NotificationListNotifier(this._repo) : super(const AsyncValue.loading()) {
    fetchAll();
  }

  Future<void> fetchAll() async {
    state = const AsyncValue.loading();
    final result = await _repo.fetchAll();
    if (result.isSuccess && result.data != null) {
      state = AsyncValue.data(result.data!);
    } else {
      state = AsyncValue.error(result.error ?? 'Failed to load notifications', StackTrace.current);
    }
  }

  Future<void> markAllRead() async {
    await _repo.markAllRead();
    await fetchAll();
  }
}

final notificationListProvider = StateNotifierProvider<NotificationListNotifier, AsyncValue<List<NotificationModel>>>((ref) {
  return NotificationListNotifier(ref.read(notificationRepositoryProvider));
});
