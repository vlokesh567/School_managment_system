class FeeSummary {
  final double totalCollected;
  final double pendingAmount;
  final double overdueAmount;
  final double collectionPercent;

  FeeSummary({
    this.totalCollected = 0,
    this.pendingAmount = 0,
    this.overdueAmount = 0,
    this.collectionPercent = 0,
  });

  String get totalCollectedLabel => '₹${_formatAmount(totalCollected)}';
  String get pendingLabel => '₹${_formatAmount(pendingAmount)}';
  String get overdueLabel => '₹${_formatAmount(overdueAmount)}';
  String get collectionLabel => '${collectionPercent.toStringAsFixed(0)}%';

  static String _formatAmount(double amount) {
    if (amount >= 100000) return '${(amount / 100000).toStringAsFixed(1)}L';
    if (amount >= 1000) return '${(amount / 1000).toStringAsFixed(1)}K';
    return amount.toStringAsFixed(0);
  }

  factory FeeSummary.fromJson(Map<String, dynamic> json) {
    return FeeSummary(
      totalCollected: (json['total_collected'] as num?)?.toDouble() ?? 0,
      pendingAmount: (json['pending_amount'] as num?)?.toDouble() ?? 0,
      overdueAmount: (json['overdue_amount'] as num?)?.toDouble() ?? 0,
      collectionPercent:
          (json['collection_percent'] as num?)?.toDouble() ?? 0,
    );
  }
}

enum TransactionStatus { paid, pending, overdue }

extension TransactionStatusX on TransactionStatus {
  String get label {
    switch (this) {
      case TransactionStatus.paid:
        return 'Paid';
      case TransactionStatus.pending:
        return 'Pending';
      case TransactionStatus.overdue:
        return 'Overdue';
    }
  }

  static TransactionStatus fromString(String s) {
    switch (s.toLowerCase()) {
      case 'paid':
        return TransactionStatus.paid;
      case 'pending':
        return TransactionStatus.pending;
      case 'overdue':
        return TransactionStatus.overdue;
      default:
        return TransactionStatus.pending;
    }
  }
}

class FeeTransaction {
  final String id;
  final String studentName;
  final double amount;
  final TransactionStatus status;
  final String date;
  final String? feeType;

  FeeTransaction({
    required this.id,
    required this.studentName,
    this.amount = 0,
    this.status = TransactionStatus.pending,
    this.date = '',
    this.feeType,
  });

  String get amountLabel => '₹${_formatAmount(amount)}';
  static String _formatAmount(double a) => a >= 1000
      ? '${(a / 1000).toStringAsFixed(1)}K'
      : a.toStringAsFixed(0);

  factory FeeTransaction.fromJson(Map<String, dynamic> json) {
    return FeeTransaction(
      id: json['id']?.toString() ?? '',
      studentName: json['student_name'] as String? ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0,
      status: TransactionStatusX.fromString(json['status'] as String? ?? ''),
      date: json['date'] as String? ?? '',
      feeType: json['fee_type'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'student_name': studentName,
        'amount': amount,
        'status': status.label,
        'date': date,
        'fee_type': feeType,
      };
}
