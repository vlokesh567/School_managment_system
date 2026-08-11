import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';

/// Manages Hive boxes for offline data caching and the sync queue.
///
/// Box naming convention:
///   - `cache_{feature}` — generic JSON-cached model lists
///   - `offline_queue` — ordered list of pending mutations
///   - `sync_meta` — last sync timestamps per feature
class HiveStorage {
  static bool _initialized = false;

  // Cache boxes — store JSON-encoded lists
  static late Box<String> cacheStudents;
  static late Box<String> cacheTeachers;
  static late Box<String> cacheAttendance;
  static late Box<String> cacheHomework;
  static late Box<String> cacheExams;
  static late Box<String> cacheFees;
  static late Box<String> cacheTransport;
  static late Box<String> cacheEvents;
  static late Box<String> cacheNotifications;
  static late Box<String> cacheTimetable;

  // Queue & meta boxes
  static late Box<String> offlineQueue;
  static late Box<String> syncMeta;

  /// Call once at app startup before any cache access.
  static Future<void> init() async {
    if (_initialized) return;
    await Hive.initFlutter();

    cacheStudents = await Hive.openBox<String>('cache_students');
    cacheTeachers = await Hive.openBox<String>('cache_teachers');
    cacheAttendance = await Hive.openBox<String>('cache_attendance');
    cacheHomework = await Hive.openBox<String>('cache_homework');
    cacheExams = await Hive.openBox<String>('cache_exams');
    cacheFees = await Hive.openBox<String>('cache_fees');
    cacheTransport = await Hive.openBox<String>('cache_transport');
    cacheEvents = await Hive.openBox<String>('cache_events');
    cacheNotifications = await Hive.openBox<String>('cache_notifications');
    cacheTimetable = await Hive.openBox<String>('cache_timetable');

    offlineQueue = await Hive.openBox<String>('offline_queue');
    syncMeta = await Hive.openBox<String>('sync_meta');

    _initialized = true;
  }

  // -- Generic cache helpers --

  /// Store a list of JSON-serializable maps under [key] for the given [box].
  static Future<void> putList(
    Box<String> box,
    String key,
    List<Map<String, dynamic>> items,
  ) async {
    await box.put(key, jsonEncode(items));
  }

  /// Retrieve a list of maps stored under [key], or null.
  static List<Map<String, dynamic>>? getList(Box<String> box, String key) {
    final raw = box.get(key);
    if (raw == null) return null;
    final decoded = jsonDecode(raw);
    if (decoded is List) {
      return decoded.cast<Map<String, dynamic>>();
    }
    return null;
  }

  /// Store a single JSON map.
  static Future<void> putMap(
    Box<String> box,
    String key,
    Map<String, dynamic> value,
  ) async {
    await box.put(key, jsonEncode(value));
  }

  /// Retrieve a single map, or null.
  static Map<String, dynamic>? getMap(Box<String> box, String key) {
    final raw = box.get(key);
    if (raw == null) return null;
    final decoded = jsonDecode(raw);
    if (decoded is Map) {
      return decoded.cast<String, dynamic>();
    }
    return null;
  }

  // -- Convenience: all keys in a box --
  static List<String> getAllKeys(Box<String> box) => box.keys.cast<String>().toList();

  // -- Clear --
  static Future<void> clearBox(Box<String> box) async {
    await box.clear();
  }
}
