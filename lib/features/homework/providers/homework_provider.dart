import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/homework_repository.dart';
import '../models/homework_model.dart';

final homeworkRepositoryProvider = Provider<HomeworkRepository>((ref) {
  return HomeworkRepository();
});

class HomeworkListNotifier extends StateNotifier<AsyncValue<List<HomeworkModel>>> {
  final HomeworkRepository _repo;

  HomeworkListNotifier(this._repo) : super(const AsyncValue.loading()) {
    fetchAll();
  }

  Future<void> fetchAll({String? statusFilter, String? classFilter}) async {
    state = const AsyncValue.loading();
    final result = await _repo.fetchAll(
      statusFilter: statusFilter,
      classFilter: classFilter,
    );
    if (result.isSuccess && result.data != null) {
      state = AsyncValue.data(result.data!);
    } else {
      state = AsyncValue.error(result.error ?? 'Failed to load homework', StackTrace.current);
    }
  }
}

final homeworkDetailProvider = FutureProvider.family<HomeworkModel, String>((ref, id) async {
  final repo = ref.read(homeworkRepositoryProvider);
  final result = await repo.fetchAll();
  if (result.isSuccess && result.data != null) {
    final hw = result.data!.where((h) => h.id == id).firstOrNull;
    if (hw != null) return hw;
  }
  throw Exception('Homework not found');
});

final homeworkListProvider = StateNotifierProvider<HomeworkListNotifier, AsyncValue<List<HomeworkModel>>>((ref) {
  return HomeworkListNotifier(ref.read(homeworkRepositoryProvider));
});
