import '../../../core/network/api_client.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/storage/hive_storage.dart';
import '../../../core/sync/offline_queue.dart';
import '../models/attendance_model.dart';

const _cacheKey = 'today';

class AttendanceRepository {
  final ApiClient _api = ApiClient.instance;

  Future<ApiResponse<List<AttendanceRecord>>> fetchToday() async {
    final today = DateTime.now().toIso8601String().split('T')[0];
    final result = await _api.getList<AttendanceRecord>(
      ApiEndpoints.attendanceByDate(today),
      fromJson: (json) =>
          AttendanceRecord.fromJson(json as Map<String, dynamic>),
    );

    if (result.isSuccess && result.data != null) {
      await HiveStorage.putList(
        HiveStorage.cacheAttendance,
        _cacheKey,
        result.data!.map((r) => r.toJson()).toList(),
      );
      return result;
    }

    // Hive cache fallback
    final cached = HiveStorage.getList(HiveStorage.cacheAttendance, _cacheKey);
    if (cached != null && cached.isNotEmpty) {
      return ApiResponse.success(
        data: cached.map((j) => AttendanceRecord.fromJson(j)).toList(),
      );
    }

    return ApiResponse.success(data: _mockRecords);
  }

  Future<ApiResponse<List<AttendanceRecord>>> fetchByDate(String date) async {
    final result = await _api.getList<AttendanceRecord>(
      ApiEndpoints.attendanceByDate(date),
      fromJson: (json) =>
          AttendanceRecord.fromJson(json as Map<String, dynamic>),
    );
    if (result.isSuccess && result.data != null) return result;
    // Fallback to today's cache
    final cached = HiveStorage.getList(HiveStorage.cacheAttendance, _cacheKey);
    if (cached != null) {
      return ApiResponse.success(
        data: cached.map((j) => AttendanceRecord.fromJson(j)).toList(),
      );
    }
    return ApiResponse.success(data: _mockRecords);
  }

  /// Mark attendance — queues offline if device is not connected.
  Future<ApiResponse<void>> markAttendance(
      List<AttendanceRecord> records) async {
    final result = await _api.post<void>(
      ApiEndpoints.attendance,
      body: {'records': records.map((r) => r.toJson()).toList()},
      fromJson: (_) => true,
    );

    if (result.isSuccess) {
      // Update local cache
      await HiveStorage.putList(
        HiveStorage.cacheAttendance,
        _cacheKey,
        records.map((r) => r.toJson()).toList(),
      );
      return result;
    }

    // Queue offline for later sync
    await OfflineQueue.enqueue(QueuedMutation(
      feature: 'attendance',
      action: 'mark_attendance',
      payload: {'records': records.map((r) => r.toJson()).toList()},
    ));

    // Still return success to the UI — the data is saved locally
    await HiveStorage.putList(
      HiveStorage.cacheAttendance,
      _cacheKey,
      records.map((r) => r.toJson()).toList(),
    );
    return ApiResponse.success(statusCode: 202);
  }

  // -- Mock data --
  List<AttendanceRecord> get _mockRecords => [
        AttendanceRecord(id: '1', studentId: '1', studentName: 'Priya Sharma', studentClass: '10A', status: AttendanceStatus.present, time: '08:45 AM'),
        AttendanceRecord(id: '2', studentId: '2', studentName: 'Rahul Verma', studentClass: '10A', status: AttendanceStatus.present, time: '08:50 AM'),
        AttendanceRecord(id: '3', studentId: '3', studentName: 'Ananya Patel', studentClass: '10B', status: AttendanceStatus.absent, time: '-'),
        AttendanceRecord(id: '4', studentId: '4', studentName: 'Arjun Singh', studentClass: '10B', status: AttendanceStatus.late, time: '09:30 AM'),
        AttendanceRecord(id: '5', studentId: '5', studentName: 'Sneha Reddy', studentClass: '9A', status: AttendanceStatus.present, time: '08:40 AM'),
        AttendanceRecord(id: '6', studentId: '6', studentName: 'Vikram Joshi', studentClass: '9A', status: AttendanceStatus.present, time: '08:55 AM'),
        AttendanceRecord(id: '7', studentId: '7', studentName: 'Neha Gupta', studentClass: '9A', status: AttendanceStatus.present, time: '08:42 AM'),
        AttendanceRecord(id: '8', studentId: '8', studentName: 'Amit Kumar', studentClass: '9B', status: AttendanceStatus.absent, time: '-'),
        AttendanceRecord(id: '9', studentId: '9', studentName: 'Divya Singh', studentClass: '9B', status: AttendanceStatus.present, time: '08:48 AM'),
        AttendanceRecord(id: '10', studentId: '10', studentName: 'Rohit Sharma', studentClass: '10B', status: AttendanceStatus.late, time: '09:15 AM'),
      ];
}
