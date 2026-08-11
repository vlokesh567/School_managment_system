import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../storage/hive_storage.dart';

/// Represents a single queued mutation that was performed offline.
class QueuedMutation {
  final String id;
  final String feature; // e.g. "attendance", "homework", "fees"
  final String action;  // e.g. "mark_attendance", "create_homework"
  final Map<String, dynamic> payload;
  final DateTime timestamp;
  int retryCount;

  QueuedMutation({
    String? id,
    required this.feature,
    required this.action,
    required this.payload,
    DateTime? timestamp,
    this.retryCount = 0,
  })  : id = id ?? const Uuid().v4(),
        timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'id': id,
        'feature': feature,
        'action': action,
        'payload': payload,
        'timestamp': timestamp.toIso8601String(),
        'retry_count': retryCount,
      };

  factory QueuedMutation.fromJson(Map<String, dynamic> json) {
    return QueuedMutation(
      id: json['id'] as String,
      feature: json['feature'] as String,
      action: json['action'] as String,
      payload: (json['payload'] as Map<String, dynamic>?) ?? {},
      timestamp: DateTime.tryParse(json['timestamp'] as String? ?? '') ?? DateTime.now(),
      retryCount: (json['retry_count'] as num?)?.toInt() ?? 0,
    );
  }
}

/// Persistent FIFO queue for offline mutations.
///
/// Each mutation is stored as a JSON string in the `offline_queue` Hive box
/// keyed by its UUID. The queue can be drained in order for sync.
class OfflineQueue {
  /// Fires whenever a mutation is enqueued or removed.
  /// Wire this to [QueueCountNotifier.refresh] for reactive UI.
  static VoidCallback? onQueueChanged;

  /// Enqueue a new mutation.
  static Future<void> enqueue(QueuedMutation mutation) async {
    final box = HiveStorage.offlineQueue;
    await box.put(mutation.id, jsonEncode(mutation.toJson()));
    onQueueChanged?.call();
  }

  /// Return all pending mutations, ordered oldest-first by timestamp.
  static List<QueuedMutation> peekAll() {
    final box = HiveStorage.offlineQueue;
    return box.keys.cast<String>().map((k) {
      final raw = box.get(k);
      if (raw == null) return null;
      return QueuedMutation.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    }).whereType<QueuedMutation>().toList()
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
  }

  /// Return mutations for a specific feature.
  static List<QueuedMutation> peekByFeature(String feature) {
    return peekAll().where((m) => m.feature == feature).toList();
  }

  /// Remove a mutation from the queue after successful sync.
  static Future<void> remove(String id) async {
    await HiveStorage.offlineQueue.delete(id);
    onQueueChanged?.call();
  }

  /// Remove all mutations.
  static Future<void> clear() async {
    await HiveStorage.offlineQueue.clear();
    onQueueChanged?.call();
  }

  /// Update retry count for a mutation.
  static Future<void> incrementRetry(String id) async {
    final box = HiveStorage.offlineQueue;
    final raw = box.get(id);
    if (raw == null) return;
    final mutation = QueuedMutation.fromJson(
        jsonDecode(raw) as Map<String, dynamic>);
    mutation.retryCount++;
    await box.put(id, jsonEncode(mutation.toJson()));
  }

  /// Number of pending mutations.
  static int get pendingCount => HiveStorage.offlineQueue.length;
}
