import '../../../core/network/api_client.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/storage/hive_storage.dart';
import '../models/transport_model.dart';

const _routesKey = 'routes';
const _liveKey = 'live';

class TransportRepository {
  final ApiClient _api = ApiClient.instance;

  Future<ApiResponse<List<TransportRoute>>> fetchRoutes() async {
    final result = await _api.getList<TransportRoute>(
      ApiEndpoints.transportRoutes,
      fromJson: (json) =>
          TransportRoute.fromJson(json as Map<String, dynamic>),
    );

    if (result.isSuccess && result.data != null) {
      await HiveStorage.putList(
        HiveStorage.cacheTransport, _routesKey,
        result.data!.map((r) => r.toJson()).toList());
      return result;
    }

    final cached = HiveStorage.getList(HiveStorage.cacheTransport, _routesKey);
    if (cached != null && cached.isNotEmpty) {
      return ApiResponse.success(
        data: cached.map((j) => TransportRoute.fromJson(j)).toList());
    }
    return ApiResponse.success(data: _mockRoutes);
  }

  Future<ApiResponse<LiveTrackingInfo>> fetchLiveTracking({String? busId}) async {
    final params = busId != null ? {'bus_id': busId} : null;
    final result = await _api.get<LiveTrackingInfo>(
      ApiEndpoints.liveTracking, queryParams: params,
      fromJson: (json) =>
          LiveTrackingInfo.fromJson(json as Map<String, dynamic>),
    );
    if (!result.isSuccess) return ApiResponse.success(data: _mockLiveTracking);
    return result;
  }

  List<TransportRoute> get _mockRoutes => [
        TransportRoute(id: '1', name: 'Route #1 - North', driverName: 'Rajesh Kumar', vehicleNumber: 'Bus A (DL-01-AB-1234)', status: 'On Time', studentCount: 32),
        TransportRoute(id: '2', name: 'Route #2 - East', driverName: 'Suresh Singh', vehicleNumber: 'Bus B (DL-02-CD-5678)', status: 'Delayed', studentCount: 28),
        TransportRoute(id: '3', name: 'Route #4 - West', driverName: 'Amit Verma', vehicleNumber: 'Bus D (DL-04-GH-9012)', status: 'On Time', studentCount: 25),
      ];

  LiveTrackingInfo get _mockLiveTracking => LiveTrackingInfo(busId: '3', routeName: 'Route #4 - West', driverName: 'Amit Verma', status: 'Moving', stops: [
        BusStop(name: 'Green Valley', eta: '2 min', status: 'next'),
        BusStop(name: 'Lake View', eta: '8 min', status: 'upcoming'),
        BusStop(name: 'School', eta: '15 min', status: 'upcoming'),
      ]);
}
