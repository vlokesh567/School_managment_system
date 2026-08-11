import 'package:flutter/material.dart' show ThemeMode;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/storage/local_storage.dart';
import '../../core/utils/constants.dart';

final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>(
  (ref) => ThemeModeNotifier(),
);

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier() : super(_getInitialMode());

  static ThemeMode _getInitialMode() {
    final isDark = LocalStorage.getBool(AppConstants.themeKey);
    return isDark ? ThemeMode.dark : ThemeMode.light;
  }

  void toggle() {
    state = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    LocalStorage.setBool(AppConstants.themeKey, state == ThemeMode.dark);
  }

  void setTheme(ThemeMode mode) {
    state = mode;
    LocalStorage.setBool(AppConstants.themeKey, mode == ThemeMode.dark);
  }
}
