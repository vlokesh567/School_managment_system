import 'dart:convert';
import '../../../core/network/api_client.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/storage/hive_storage.dart';
import '../models/timetable_model.dart';
import '../../../app/theme/app_colors.dart';

class TimetableRepository {
  final ApiClient _api = ApiClient.instance;

  Future<ApiResponse<Map<int, List<TimetableEntry>>>> fetchByClass(
      String classId) async {
    final result = await _api.get<Map<int, List<TimetableEntry>>>(
      ApiEndpoints.timetableByClass(classId),
      fromJson: (_) => _mockTimetable,
    );

    if (result.isSuccess) {
      // Cache as JSON string
      final json = jsonEncode(_timetableToJson(_mockTimetable));
      await HiveStorage.cacheTimetable.put(classId, json);
      return result;
    }

    // Try Hive cache
    final raw = HiveStorage.cacheTimetable.get(classId);
    if (raw != null) {
      final decoded = jsonDecode(raw);
      if (decoded is Map) {
        final parsed = (decoded as Map<String, dynamic>).map(
          (k, v) => MapEntry(
            int.parse(k),
            (v as List).map((e) => TimetableEntry.fromJson(e as Map<String, dynamic>)).toList(),
          ),
        );
        return ApiResponse.success(data: parsed);
      }
    }
    return ApiResponse.success(data: _mockTimetable);
  }

  Map<String, dynamic> _timetableToJson(Map<int, List<TimetableEntry>> tt) {
    return tt.map((k, v) => MapEntry(k.toString(), v.map((e) => e.toJson()).toList()));
  }

  final Map<int, List<TimetableEntry>> _mockTimetable = {
    0: [
      TimetableEntry(subject: 'Mathematics', teacher: 'Mrs. Sharma', time: '08:00 - 08:45', room: '101', color: AppColors.danger),
      TimetableEntry(subject: 'Science', teacher: 'Mr. Verma', time: '08:45 - 09:30', room: '102', color: AppColors.success),
      TimetableEntry(subject: 'Break', time: '09:30 - 09:45', isBreak: true),
      TimetableEntry(subject: 'English', teacher: 'Mrs. Singh', time: '09:45 - 10:30', room: '103', color: AppColors.info),
      TimetableEntry(subject: 'Hindi', teacher: 'Ms. Gupta', time: '10:30 - 11:15', room: '104', color: AppColors.warning),
      TimetableEntry(subject: 'Physical Education', teacher: 'Mr. Yadav', time: '11:15 - 12:00', room: 'Ground', color: AppColors.accent),
    ],
    1: [
      TimetableEntry(subject: 'Geography', teacher: 'Mr. Patel', time: '08:00 - 08:45', room: '105', color: AppColors.accent),
      TimetableEntry(subject: 'Mathematics', teacher: 'Mrs. Sharma', time: '08:45 - 09:30', room: '101', color: AppColors.danger),
      TimetableEntry(subject: 'Break', time: '09:30 - 09:45', isBreak: true),
      TimetableEntry(subject: 'Science (Lab)', teacher: 'Mr. Verma', time: '09:45 - 10:30', room: 'Lab 1', color: AppColors.success),
      TimetableEntry(subject: 'Art & Craft', teacher: 'Mrs. Kapoor', time: '10:30 - 11:15', room: 'Art Room', color: AppColors.accentLight),
      TimetableEntry(subject: 'English', teacher: 'Mrs. Singh', time: '11:15 - 12:00', room: '103', color: AppColors.info),
    ],
    2: [
      TimetableEntry(subject: 'Science', teacher: 'Mr. Verma', time: '08:00 - 08:45', room: '102', color: AppColors.success),
      TimetableEntry(subject: 'Hindi', teacher: 'Ms. Gupta', time: '08:45 - 09:30', room: '104', color: AppColors.warning),
      TimetableEntry(subject: 'Break', time: '09:30 - 09:45', isBreak: true),
      TimetableEntry(subject: 'Mathematics', teacher: 'Mrs. Sharma', time: '09:45 - 10:30', room: '101', color: AppColors.danger),
      TimetableEntry(subject: 'History', teacher: 'Mr. Kumar', time: '10:30 - 11:15', room: '106', color: AppColors.primary),
      TimetableEntry(subject: 'Computer Science', teacher: 'Mrs. Mehta', time: '11:15 - 12:00', room: 'Computer Lab', color: AppColors.infoLight),
    ],
    3: [
      TimetableEntry(subject: 'English', teacher: 'Mrs. Singh', time: '08:00 - 08:45', room: '103', color: AppColors.info),
      TimetableEntry(subject: 'Mathematics', teacher: 'Mrs. Sharma', time: '08:45 - 09:30', room: '101', color: AppColors.danger),
      TimetableEntry(subject: 'Break', time: '09:30 - 09:45', isBreak: true),
      TimetableEntry(subject: 'Geography', teacher: 'Mr. Patel', time: '09:45 - 10:30', room: '105', color: AppColors.accent),
      TimetableEntry(subject: 'Science', teacher: 'Mr. Verma', time: '10:30 - 11:15', room: '102', color: AppColors.success),
      TimetableEntry(subject: 'Sports', teacher: 'Mr. Yadav', time: '11:15 - 12:00', room: 'Ground', color: AppColors.accentLight),
    ],
    4: [
      TimetableEntry(subject: 'Hindi', teacher: 'Ms. Gupta', time: '08:00 - 08:45', room: '104', color: AppColors.warning),
      TimetableEntry(subject: 'Science', teacher: 'Mr. Verma', time: '08:45 - 09:30', room: '102', color: AppColors.success),
      TimetableEntry(subject: 'Break', time: '09:30 - 09:45', isBreak: true),
      TimetableEntry(subject: 'Mathematics', teacher: 'Mrs. Sharma', time: '09:45 - 10:30', room: '101', color: AppColors.danger),
      TimetableEntry(subject: 'English', teacher: 'Mrs. Singh', time: '10:30 - 11:15', room: '103', color: AppColors.info),
      TimetableEntry(subject: 'Moral Science', teacher: 'Mr. Kumar', time: '11:15 - 12:00', room: '106', color: AppColors.accent),
    ],
    5: [
      TimetableEntry(subject: 'Science (Lab)', teacher: 'Mr. Verma', time: '08:00 - 08:45', room: 'Lab 1', color: AppColors.success),
      TimetableEntry(subject: 'Mathematics', teacher: 'Mrs. Sharma', time: '08:45 - 09:30', room: '101', color: AppColors.danger),
      TimetableEntry(subject: 'Break', time: '09:30 - 09:45', isBreak: true),
      TimetableEntry(subject: 'English', teacher: 'Mrs. Singh', time: '09:45 - 10:30', room: '103', color: AppColors.info),
      TimetableEntry(subject: 'Library', teacher: 'Mrs. Kapoor', time: '10:30 - 11:15', room: 'Library', color: AppColors.primaryLight),
      TimetableEntry(subject: 'Physical Education', teacher: 'Mr. Yadav', time: '11:15 - 12:00', room: 'Ground', color: AppColors.accent),
    ],
  };
}
