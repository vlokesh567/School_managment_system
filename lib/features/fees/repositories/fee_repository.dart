import '../../../core/network/api_client.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/storage/hive_storage.dart';
import '../models/fee_model.dart';

const _summaryKey = 'summary';
const _txKey = 'transactions';

class FeeRepository {
  final ApiClient _api = ApiClient.instance;

  Future<ApiResponse<FeeSummary>> fetchSummary() async {
    final result = await _api.get<FeeSummary>(
      ApiEndpoints.fees,
      fromJson: (json) => FeeSummary.fromJson(json as Map<String, dynamic>),
    );

    if (result.isSuccess && result.data != null) {
      await HiveStorage.putMap(
        HiveStorage.cacheFees, _summaryKey, result.data!.toJson());
      return result;
    }

    final cached = HiveStorage.getMap(HiveStorage.cacheFees, _summaryKey);
    if (cached != null) {
      return ApiResponse.success(data: FeeSummary.fromJson(cached));
    }
    return ApiResponse.success(data: _mockSummary);
  }

  Future<ApiResponse<List<FeeTransaction>>> fetchTransactions() async {
    final result = await _api.getList<FeeTransaction>(
      ApiEndpoints.feeTransactions,
      fromJson: (json) =>
          FeeTransaction.fromJson(json as Map<String, dynamic>),
    );

    if (result.isSuccess && result.data != null) {
      await HiveStorage.putList(
        HiveStorage.cacheFees, _txKey,
        result.data!.map((t) => t.toJson()).toList());
      return result;
    }

    final cached = HiveStorage.getList(HiveStorage.cacheFees, _txKey);
    if (cached != null && cached.isNotEmpty) {
      return ApiResponse.success(
        data: cached.map((j) => FeeTransaction.fromJson(j)).toList());
    }
    return ApiResponse.success(data: _mockTransactions);
  }

  // -- Mock data --
  FeeSummary get _mockSummary => FeeSummary(totalCollected: 1250000, pendingAmount: 320000, overdueAmount: 85000, collectionPercent: 78);
  List<FeeTransaction> get _mockTransactions => [
        FeeTransaction(id: '1', studentName: 'Ravi Kumar', amount: 25000, status: TransactionStatus.paid, date: 'Today'),
        FeeTransaction(id: '2', studentName: 'Priya Sharma', amount: 25000, status: TransactionStatus.paid, date: 'Yesterday'),
        FeeTransaction(id: '3', studentName: 'Amit Singh', amount: 12500, status: TransactionStatus.pending, date: '2 days ago'),
        FeeTransaction(id: '4', studentName: 'Sneha Patel', amount: 25000, status: TransactionStatus.overdue, date: '5 days ago'),
      ];
}

// Add toJson to FeeSummary for Hive caching
extension FeeSummaryJson on FeeSummary {
  Map<String, dynamic> toJson() => {
        'total_collected': totalCollected,
        'pending_amount': pendingAmount,
        'overdue_amount': overdueAmount,
        'collection_percent': collectionPercent,
      };
}
