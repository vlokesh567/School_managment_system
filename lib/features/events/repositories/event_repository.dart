import 'package:flutter/material.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/storage/hive_storage.dart';
import '../models/event_model.dart';

const _cacheKey = 'all';

class EventRepository {
  final ApiClient _api = ApiClient.instance;

  Future<ApiResponse<List<EventModel>>> fetchAll() async {
    final result = await _api.getList<EventModel>(
      ApiEndpoints.events,
      fromJson: (json) => EventModel.fromJson(json as Map<String, dynamic>),
    );

    if (result.isSuccess && result.data != null) {
      await HiveStorage.putList(
        HiveStorage.cacheEvents, _cacheKey,
        result.data!.map((e) => e.toJson()).toList());
      return result;
    }

    final cached = HiveStorage.getList(HiveStorage.cacheEvents, _cacheKey);
    if (cached != null && cached.isNotEmpty) {
      return ApiResponse.success(
        data: cached.map((j) => EventModel.fromJson(j)).toList());
    }
    return ApiResponse.success(data: _mockEvents);
  }

  List<EventModel> get _mockEvents => [
        EventModel(id: '1', title: 'Annual Sports Day', date: '20 Dec 2024', type: 'Event', description: 'Annual sports competition for all classes', color: const Color(0xFF6366F1)),
        EventModel(id: '2', title: 'Parent-Teacher Meeting', date: '22 Dec 2024', type: 'Meeting', description: 'PTM for Class 10 students', color: const Color(0xFFA78BFA)),
        EventModel(id: '3', title: 'Winter Break', date: '25 Dec - 05 Jan', type: 'Holiday', description: 'School will remain closed', color: const Color(0xFF22C55E)),
        EventModel(id: '4', title: 'Science Exhibition', date: '15 Jan 2025', type: 'Event', description: 'Science project exhibition for classes 9-12', color: const Color(0xFFF59E0B)),
        EventModel(id: '5', title: 'Republic Day Celebration', date: '26 Jan 2025', type: 'Celebration', description: 'Flag hoisting and cultural program', color: const Color(0xFFEF4444)),
      ];
}
