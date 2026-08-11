import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/fee_repository.dart';
import '../models/fee_model.dart';

final feeRepositoryProvider = Provider<FeeRepository>((ref) {
  return FeeRepository();
});

class FeeDashboardData {
  final FeeSummary summary;
  final List<FeeTransaction> transactions;

  FeeDashboardData({required this.summary, required this.transactions});
}

class FeeDashboardNotifier extends StateNotifier<AsyncValue<FeeDashboardData>> {
  final FeeRepository _repo;

  FeeDashboardNotifier(this._repo) : super(const AsyncValue.loading()) {
    fetchAll();
  }

  Future<void> fetchAll() async {
    state = const AsyncValue.loading();
    final summaryResult = await _repo.fetchSummary();
    final txResult = await _repo.fetchTransactions();
    if (summaryResult.isSuccess && txResult.isSuccess &&
        summaryResult.data != null && txResult.data != null) {
      state = AsyncValue.data(FeeDashboardData(
        summary: summaryResult.data!,
        transactions: txResult.data!,
      ));
    } else {
      state = AsyncValue.error('Failed to load fee data', StackTrace.current);
    }
  }
}

final feeDashboardProvider = StateNotifierProvider<FeeDashboardNotifier, AsyncValue<FeeDashboardData>>((ref) {
  return FeeDashboardNotifier(ref.read(feeRepositoryProvider));
});
