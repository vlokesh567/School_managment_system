import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/transport_repository.dart';
import '../models/transport_model.dart';

final transportRepositoryProvider = Provider<TransportRepository>((ref) {
  return TransportRepository();
});

class TransportDashboardData {
  final List<TransportRoute> routes;
  final LiveTrackingInfo liveTracking;

  TransportDashboardData({required this.routes, required this.liveTracking});
}

class TransportDashboardNotifier extends StateNotifier<AsyncValue<TransportDashboardData>> {
  final TransportRepository _repo;

  TransportDashboardNotifier(this._repo) : super(const AsyncValue.loading()) {
    fetchAll();
  }

  Future<void> fetchAll() async {
    state = const AsyncValue.loading();
    final routesResult = await _repo.fetchRoutes();
    final liveResult = await _repo.fetchLiveTracking();
    if (routesResult.isSuccess && liveResult.isSuccess &&
        routesResult.data != null && liveResult.data != null) {
      state = AsyncValue.data(TransportDashboardData(
        routes: routesResult.data!,
        liveTracking: liveResult.data!,
      ));
    } else {
      state = AsyncValue.error('Failed to load transport data', StackTrace.current);
    }
  }
}

final transportDashboardProvider = StateNotifierProvider<TransportDashboardNotifier, AsyncValue<TransportDashboardData>>((ref) {
  return TransportDashboardNotifier(ref.read(transportRepositoryProvider));
});
