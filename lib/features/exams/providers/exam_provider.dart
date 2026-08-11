import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/exam_repository.dart';
import '../models/exam_model.dart';

final examRepositoryProvider = Provider<ExamRepository>((ref) {
  return ExamRepository();
});

class ExamListNotifier extends StateNotifier<AsyncValue<List<ExamModel>>> {
  final ExamRepository _repo;

  ExamListNotifier(this._repo) : super(const AsyncValue.loading()) {
    fetchAll();
  }

  Future<void> fetchAll() async {
    state = const AsyncValue.loading();
    final result = await _repo.fetchAll();
    if (result.isSuccess && result.data != null) {
      state = AsyncValue.data(result.data!);
    } else {
      state = AsyncValue.error(result.error ?? 'Failed to load exams', StackTrace.current);
    }
  }
}

final examListProvider = StateNotifierProvider<ExamListNotifier, AsyncValue<List<ExamModel>>>((ref) {
  return ExamListNotifier(ref.read(examRepositoryProvider));
});
