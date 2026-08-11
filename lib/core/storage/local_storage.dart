import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // String
  static Future<void> setString(String key, String value) async {
    await _prefs.setString(key, value);
  }

  static String? getString(String key) {
    return _prefs.getString(key);
  }

  // Bool
  static Future<void> setBool(String key, bool value) async {
    await _prefs.setBool(key, value);
  }

  static bool getBool(String key, {bool defaultValue = false}) {
    return _prefs.getBool(key) ?? defaultValue;
  }

  // Int
  static Future<void> setInt(String key, int value) async {
    await _prefs.setInt(key, value);
  }

  static int? getInt(String key) {
    return _prefs.getInt(key);
  }

  // JSON
  static Future<void> setJson(String key, Map<String, dynamic> value) async {
    await _prefs.setString(key, jsonEncode(value));
  }

  static Map<String, dynamic>? getJson(String key) {
    final string = _prefs.getString(key);
    if (string == null) return null;
    return jsonDecode(string) as Map<String, dynamic>;
  }

  // List
  static Future<void> setList(String key, List<dynamic> value) async {
    await _prefs.setString(key, jsonEncode(value));
  }

  static List<dynamic>? getList(String key) {
    final string = _prefs.getString(key);
    if (string == null) return null;
    return jsonDecode(string) as List<dynamic>;
  }

  // Delete
  static Future<void> remove(String key) async {
    await _prefs.remove(key);
  }

  // Clear
  static Future<void> clear() async {
    await _prefs.clear();
  }
}
