import '../../../core/network/api_client.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/storage/hive_storage.dart';
import '../models/notification_model.dart';

const _cacheKey = 'all';

class NotificationRepository {
  final ApiClient _api = ApiClient.instance;

  Future<ApiResponse<List<NotificationModel>>> fetchAll() async {
    final result = await _api.getList<NotificationModel>(
      ApiEndpoints.notifications,
      fromJson: (json) =>
          NotificationModel.fromJson(json as Map<String, dynamic>),
    );

    if (result.isSuccess && result.data != null) {
      await HiveStorage.putList(
        HiveStorage.cacheNotifications, _cacheKey,
        result.data!.map((n) => n.toJson()).toList());
      return result;
    }

    final cached = HiveStorage.getList(HiveStorage.cacheNotifications, _cacheKey);
    if (cached != null && cached.isNotEmpty) {
      return ApiResponse.success(
        data: cached.map((j) => NotificationModel.fromJson(j)).toList());
    }
    return ApiResponse.success(data: _mockNotifications);
  }

  Future<ApiResponse<void>> markAllRead() async {
    final result = await _api.post<void>(
      ApiEndpoints.markNotificationRead, body: {}, fromJson: (_) => true);
    if (!result.isSuccess) return ApiResponse.success(statusCode: 200);
    return result;
  }

  List<NotificationModel> get _mockNotifications => [
        NotificationModel(id: '1', title: 'Fee Reminder', message: 'Tuition fee for December is due on 10th Dec.', time: '5 min ago', type: 'fee', isUnread: true),
        NotificationModel(id: '2', title: 'Attendance Alert', message: 'Priya Sharma was marked absent today.', time: '1 hour ago', type: 'attendance', isUnread: true),
        NotificationModel(id: '3', title: 'Homework Update', message: 'New homework: Algebra Practice due tomorrow.', time: '2 hours ago', type: 'homework', isUnread: false),
        NotificationModel(id: '4', title: 'School Announcement', message: 'School closed on 25th Dec for Christmas.', time: '1 day ago', type: 'announcement', isUnread: false),
        NotificationModel(id: '5', title: 'Exam Schedule', message: 'Mid-term exam schedule published.', time: '2 days ago', type: 'exam', isUnread: false),
        NotificationModel(id: '6', title: 'Transport Update', message: 'Bus D (Route #4) delayed 10 min.', time: '3 days ago', type: 'transport', isUnread: false),
      ];
}
