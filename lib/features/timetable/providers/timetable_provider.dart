import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/timetable_repository.dart';
import '../models/timetable_model.dart';

final timetableRepositoryProvider = Provider<TimetableRepository>((ref) {
  return TimetableRepository();
});

class TimetableNotifier extends StateNotifier<AsyncValue<Map<int, List<TimetableEntry>>>> {
  final TimetableRepository _repo;
  final String _classId;

  TimetableNotifier(this._repo, this._classId) : super(const AsyncValue.loading()) {
    fetch();
  }

  Future<void> fetch() async {
    state = const AsyncValue.loading();
    final result = await _repo.fetchByClass(_classId);
    if (result.isSuccess && result.data != null) {
      state = AsyncValue.data(result.data!);
    } else {
      state = AsyncValue.error(result.error ?? 'Failed to load timetable', StackTrace.current);
    }
  }
}

final timetableProvider = StateNotifierProvider.family<TimetableNotifier, AsyncValue<Map<int, List<TimetableEntry>>>, String>((ref, classId) {
  return TimetableNotifier(ref.read(timetableRepositoryProvider), classId);
});
