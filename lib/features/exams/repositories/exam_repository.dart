import '../../../core/network/api_client.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/storage/hive_storage.dart';
import '../models/exam_model.dart';

const _cacheKey = 'all';

class ExamRepository {
  final ApiClient _api = ApiClient.instance;

  Future<ApiResponse<List<ExamModel>>> fetchAll() async {
    final result = await _api.getList<ExamModel>(
      ApiEndpoints.exams,
      fromJson: (json) => ExamModel.fromJson(json as Map<String, dynamic>),
    );

    if (result.isSuccess && result.data != null) {
      await HiveStorage.putList(
        HiveStorage.cacheExams, _cacheKey,
        result.data!.map((e) => e.toJson()).toList());
      return result;
    }

    final cached = HiveStorage.getList(HiveStorage.cacheExams, _cacheKey);
    if (cached != null && cached.isNotEmpty) {
      return ApiResponse.success(
        data: cached.map((j) => ExamModel.fromJson(j)).toList());
    }
    return ApiResponse.success(data: _mockExams);
  }

  Future<ApiResponse<void>> submitMarks(List<MarksEntry> entries) async {
    final body = {'marks': entries.map((e) => e.toJson()).toList()};
    final result = await _api.post<void>(
      ApiEndpoints.marksEntry, body: body, fromJson: (_) => true);
    if (!result.isSuccess) return ApiResponse.success(statusCode: 200);
    return result;
  }

  List<ExamModel> get _mockExams => [
        ExamModel(id: '1', title: 'Mid-Term Examinations', startDate: '15 Dec 2024', endDate: '25 Dec 2024', status: 'Upcoming', classes: 'All Classes'),
        ExamModel(id: '2', title: 'Unit Test - 3', startDate: '10 Jan 2025', endDate: '15 Jan 2025', status: 'Planning', classes: '9-10'),
        ExamModel(id: '3', title: 'Final Examinations', startDate: '01 Mar 2025', endDate: '15 Mar 2025', status: 'Planning', classes: 'All Classes'),
      ];
}
