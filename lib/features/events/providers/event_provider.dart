import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/event_repository.dart';
import '../models/event_model.dart';

final eventRepositoryProvider = Provider<EventRepository>((ref) {
  return EventRepository();
});

class EventListNotifier extends StateNotifier<AsyncValue<List<EventModel>>> {
  final EventRepository _repo;

  EventListNotifier(this._repo) : super(const AsyncValue.loading()) {
    fetchAll();
  }

  Future<void> fetchAll() async {
    state = const AsyncValue.loading();
    final result = await _repo.fetchAll();
    if (result.isSuccess && result.data != null) {
      state = AsyncValue.data(result.data!);
    } else {
      state = AsyncValue.error(result.error ?? 'Failed to load events', StackTrace.current);
    }
  }
}

final eventListProvider = StateNotifierProvider<EventListNotifier, AsyncValue<List<EventModel>>>((ref) {
  return EventListNotifier(ref.read(eventRepositoryProvider));
});
