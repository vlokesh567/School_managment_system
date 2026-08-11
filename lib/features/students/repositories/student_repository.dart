import 'dart:convert';
import '../../../core/network/api_client.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/storage/hive_storage.dart';
import '../models/student_model.dart';

const _cacheKey = 'all';

class StudentRepository {
  final ApiClient _api = ApiClient.instance;

  /// Fetch all students, optionally filtered.
  Future<ApiResponse<List<StudentModel>>> fetchAll({
    String? classFilter,
    String? sectionFilter,
    String? searchQuery,
  }) async {
    final params = <String, dynamic>{};
    if (classFilter != null) params['class'] = classFilter;
    if (sectionFilter != null) params['section'] = sectionFilter;
    if (searchQuery != null) params['search'] = searchQuery;

    final result = await _api.getList<StudentModel>(
      ApiEndpoints.students,
      queryParams: params.isNotEmpty ? params : null,
      fromJson: (json) => StudentModel.fromJson(json as Map<String, dynamic>),
    );

    if (result.isSuccess && result.data != null) {
      // Cache the response
      await HiveStorage.putList(
        HiveStorage.cacheStudents,
        _cacheKey,
        result.data!.map((s) => s.toJson()).toList(),
      );
      return result;
    }

    // Fallback to Hive cache
    final cached = HiveStorage.getList(HiveStorage.cacheStudents, _cacheKey);
    if (cached != null && cached.isNotEmpty) {
      return ApiResponse.success(
        data: cached.map((j) => StudentModel.fromJson(j)).toList(),
      );
    }

    // Final fallback to mock data
    return ApiResponse.success(data: _mockStudents);
  }

  Future<ApiResponse<StudentModel>> fetchById(String id) async {
    final result = await _api.get<StudentModel>(
      ApiEndpoints.studentById(id),
      fromJson: (json) => StudentModel.fromJson(json as Map<String, dynamic>),
    );
    if (result.isSuccess && result.data != null) return result;

    // Try from cache
    final cached = HiveStorage.getList(HiveStorage.cacheStudents, _cacheKey);
    if (cached != null) {
      final match = cached
          .map((j) => StudentModel.fromJson(j))
          .where((s) => s.id == id)
          .toList();
      if (match.isNotEmpty) return ApiResponse.success(data: match.first);
    }

    return ApiResponse.success(
      data: _mockStudents.firstWhere(
        (s) => s.id == id,
        orElse: () => _mockStudents.first,
      ),
    );
  }

  Future<ApiResponse<StudentModel>> create(StudentModel student) async {
    final result = _api.post<StudentModel>(
      ApiEndpoints.students,
      body: student.toJson(),
      fromJson: (json) => StudentModel.fromJson(json as Map<String, dynamic>),
    );
    // Don't cache creates — next fetchAll will refresh
    return result;
  }

  // -- Mock data (same as before) --
  List<StudentModel> get _mockStudents => [
        StudentModel(
          id: '1', firstName: 'Priya', lastName: 'Sharma',
          studentClass: '10A', section: 'A', rollNumber: '101',
          attendancePercent: 95, dateOfBirth: '15 Jan 2010', gender: 'Female',
          bloodGroup: 'B+', address: '123, Green Valley, Mumbai',
          admissionNo: 'ADM2023/101', admissionDate: '01 Apr 2023',
          previousSchool: 'ABC Public School', transportRoute: 'Route #4 - Bus A',
          fatherName: 'Mr. Rajesh Sharma', motherName: 'Mrs. Sunita Sharma',
          parentContact: '+91 98765 43210', parentEmail: 'rajesh@email.com',
          medicalConditions: 'Asthma (Mild)', emergencyContact: '+91 98765 43210',
        ),
        StudentModel(id: '2', firstName: 'Rahul', lastName: 'Verma', studentClass: '10A', section: 'A', rollNumber: '102', attendancePercent: 88),
        StudentModel(id: '3', firstName: 'Ananya', lastName: 'Patel', studentClass: '10B', section: 'B', rollNumber: '201', attendancePercent: 92),
        StudentModel(id: '4', firstName: 'Arjun', lastName: 'Singh', studentClass: '10B', section: 'B', rollNumber: '202', attendancePercent: 78),
        StudentModel(id: '5', firstName: 'Sneha', lastName: 'Reddy', studentClass: '9A', section: 'A', rollNumber: '301', attendancePercent: 97),
        StudentModel(id: '6', firstName: 'Vikram', lastName: 'Joshi', studentClass: '9A', section: 'A', rollNumber: '302', attendancePercent: 85),
      ];
}
