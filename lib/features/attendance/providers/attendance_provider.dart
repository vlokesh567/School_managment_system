import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/attendance_repository.dart';
import '../models/attendance_model.dart';

final attendanceRepositoryProvider = Provider<AttendanceRepository>((ref) {
  return AttendanceRepository();
});

class AttendanceListNotifier extends StateNotifier<AsyncValue<List<AttendanceRecord>>> {
  final AttendanceRepository _repo;

  AttendanceListNotifier(this._repo) : super(const AsyncValue.loading()) {
    fetchToday();
  }

  Future<void> fetchToday() async {
    state = const AsyncValue.loading();
    final result = await _repo.fetchToday();
    if (result.isSuccess && result.data != null) {
      state = AsyncValue.data(result.data!);
    } else {
      state = AsyncValue.error(result.error ?? 'Failed to load attendance', StackTrace.current);
    }
  }

  Future<void> markAttendance(List<AttendanceRecord> records) async {
    await _repo.markAttendance(records);
    await fetchToday();
  }
}

final attendanceListProvider = StateNotifierProvider<AttendanceListNotifier, AsyncValue<List<AttendanceRecord>>>((ref) {
  return AttendanceListNotifier(ref.read(attendanceRepositoryProvider));
});
