import '../../../core/network/api_client.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/storage/hive_storage.dart';
import '../models/teacher_model.dart';

const _cacheKey = 'all';

class TeacherRepository {
  final ApiClient _api = ApiClient.instance;

  Future<ApiResponse<List<TeacherModel>>> fetchAll({String? searchQuery}) async {
    final params = searchQuery != null ? {'search': searchQuery} : null;
    final result = await _api.getList<TeacherModel>(
      ApiEndpoints.teachers,
      queryParams: params,
      fromJson: (json) => TeacherModel.fromJson(json as Map<String, dynamic>),
    );

    if (result.isSuccess && result.data != null) {
      await HiveStorage.putList(
        HiveStorage.cacheTeachers,
        _cacheKey,
        result.data!.map((t) => t.toJson()).toList(),
      );
      return result;
    }

    final cached = HiveStorage.getList(HiveStorage.cacheTeachers, _cacheKey);
    if (cached != null && cached.isNotEmpty) {
      return ApiResponse.success(
        data: cached.map((j) => TeacherModel.fromJson(j)).toList(),
      );
    }
    return ApiResponse.success(data: _mockTeachers);
  }

  Future<ApiResponse<TeacherModel>> create(TeacherModel teacher) async {
    return _api.post<TeacherModel>(
      ApiEndpoints.teachers,
      body: teacher.toJson(),
      fromJson: (json) => TeacherModel.fromJson(json as Map<String, dynamic>),
    );
  }

  List<TeacherModel> get _mockTeachers => [
        TeacherModel(id: '1', firstName: 'Ananya', lastName: 'Sharma', subjects: 'Mathematics, Science', assignedClasses: '10A, 10B', studentCount: 85, phone: '+91 98765 43211', email: 'ananya@springdale.edu', qualification: 'M.Ed'),
        TeacherModel(id: '2', firstName: 'Rajesh', lastName: 'Kumar', subjects: 'English, History', assignedClasses: '9A, 9B', studentCount: 92),
        TeacherModel(id: '3', firstName: 'Priya', lastName: 'Patel', subjects: 'Hindi, Sanskrit', assignedClasses: '10A, 9A', studentCount: 78),
        TeacherModel(id: '4', firstName: 'Vikram', lastName: 'Singh', subjects: 'Physics, Chemistry', assignedClasses: '10A, 10B, 9A', studentCount: 120),
      ];
}
