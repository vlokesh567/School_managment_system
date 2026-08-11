import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/student_repository.dart';
import '../models/student_model.dart';

final studentRepositoryProvider = Provider<StudentRepository>((ref) {
  return StudentRepository();
});

/// Notifier that manages student list state with loading, data, and error.
class StudentListNotifier extends StateNotifier<AsyncValue<List<StudentModel>>> {
  final StudentRepository _repo;

  StudentListNotifier(this._repo) : super(const AsyncValue.loading()) {
    fetchAll();
  }

  Future<void> fetchAll({String? classFilter, String? sectionFilter, String? searchQuery}) async {
    state = const AsyncValue.loading();
    final result = await _repo.fetchAll(
      classFilter: classFilter,
      sectionFilter: sectionFilter,
      searchQuery: searchQuery,
    );
    if (result.isSuccess && result.data != null) {
      state = AsyncValue.data(result.data!);
    } else {
      state = AsyncValue.error(result.error ?? 'Failed to load students', StackTrace.current);
    }
  }
}

final studentListProvider = StateNotifierProvider<StudentListNotifier, AsyncValue<List<StudentModel>>>((ref) {
  return StudentListNotifier(ref.read(studentRepositoryProvider));
});

/// Single student detail provider (family by id).
final studentDetailProvider = FutureProvider.family<StudentModel, String>((ref, id) async {
  final repo = ref.read(studentRepositoryProvider);
  final result = await repo.fetchById(id);
  if (result.isSuccess && result.data != null) {
    return result.data!;
  }
  throw result.error ?? 'Student not found';
});
