import 'package:flutter/material.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/storage/hive_storage.dart';
import '../models/homework_model.dart';

const _cacheKey = 'all';

class HomeworkRepository {
  final ApiClient _api = ApiClient.instance;

  Future<ApiResponse<List<HomeworkModel>>> fetchAll({
    String? statusFilter,
    String? classFilter,
  }) async {
    final params = <String, dynamic>{};
    if (statusFilter != null) params['status'] = statusFilter;
    if (classFilter != null) params['class'] = classFilter;

    final result = await _api.getList<HomeworkModel>(
      ApiEndpoints.homework,
      queryParams: params.isNotEmpty ? params : null,
      fromJson: (json) =>
          HomeworkModel.fromJson(json as Map<String, dynamic>),
    );

    if (result.isSuccess && result.data != null) {
      await HiveStorage.putList(
        HiveStorage.cacheHomework,
        _cacheKey,
        result.data!.map((h) => h.toJson()).toList(),
      );
      return result;
    }

    final cached = HiveStorage.getList(HiveStorage.cacheHomework, _cacheKey);
    if (cached != null && cached.isNotEmpty) {
      return ApiResponse.success(
        data: cached.map((j) => HomeworkModel.fromJson(j)).toList(),
      );
    }
    return ApiResponse.success(data: _mockHomework);
  }

  Future<ApiResponse<HomeworkModel>> create(HomeworkModel hw) async {
    // In real app, queue offline if not connected
    return _api.post<HomeworkModel>(
      ApiEndpoints.homework,
      body: hw.toJson(),
      fromJson: (json) =>
          HomeworkModel.fromJson(json as Map<String, dynamic>),
    );
  }

  List<HomeworkModel> get _mockHomework => [
        HomeworkModel(id: '1', title: 'Algebra Practice', subject: 'Mathematics', teacher: 'Mrs. Sharma', studentClass: '10A', dueDate: 'Today', status: 'Pending', submittedCount: 32, totalCount: 45, subjectColor: const Color(0xFFEF4444)),
        HomeworkModel(id: '2', title: 'Chemical Reactions', subject: 'Science', teacher: 'Mr. Verma', studentClass: '10A', dueDate: 'Tomorrow', status: 'Pending', submittedCount: 0, totalCount: 45, subjectColor: const Color(0xFF22C55E)),
        HomeworkModel(id: '3', title: 'Essay on Climate Change', subject: 'English', teacher: 'Mrs. Singh', studentClass: '10B', dueDate: '2 days', status: 'Active', submittedCount: 28, totalCount: 40, subjectColor: const Color(0xFF3B82F6)),
        HomeworkModel(id: '4', title: 'Map Work - India', subject: 'Geography', teacher: 'Mr. Patel', studentClass: '9A', dueDate: '3 days', status: 'Active', submittedCount: 15, totalCount: 38, subjectColor: const Color(0xFFA78BFA)),
        HomeworkModel(id: '5', title: 'Hindi Grammar', subject: 'Hindi', teacher: 'Ms. Gupta', studentClass: '10A', dueDate: 'Last week', status: 'Submitted', submittedCount: 45, totalCount: 45, subjectColor: const Color(0xFFF59E0B)),
      ];
}
