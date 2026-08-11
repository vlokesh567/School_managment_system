import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/teacher_repository.dart';
import '../models/teacher_model.dart';

final teacherRepositoryProvider = Provider<TeacherRepository>((ref) {
  return TeacherRepository();
});

class TeacherListNotifier extends StateNotifier<AsyncValue<List<TeacherModel>>> {
  final TeacherRepository _repo;

  TeacherListNotifier(this._repo) : super(const AsyncValue.loading()) {
    fetchAll();
  }

  Future<void> fetchAll({String? searchQuery}) async {
    state = const AsyncValue.loading();
    final result = await _repo.fetchAll(searchQuery: searchQuery);
    if (result.isSuccess && result.data != null) {
      state = AsyncValue.data(result.data!);
    } else {
      state = AsyncValue.error(result.error ?? 'Failed to load teachers', StackTrace.current);
    }
  }
}

final teacherListProvider = StateNotifierProvider<TeacherListNotifier, AsyncValue<List<TeacherModel>>>((ref) {
  return TeacherListNotifier(ref.read(teacherRepositoryProvider));
});

/// Single teacher detail provider (family by id).
final teacherDetailProvider = FutureProvider.family<TeacherModel, String>((ref, id) async {
  final repo = ref.read(teacherRepositoryProvider);
  final result = await repo.fetchAll();
  if (result.isSuccess && result.data != null) {
    final match = result.data!.where((t) => t.id == id).toList();
    if (match.isNotEmpty) return match.first;
  }
  throw 'Teacher not found';
});
