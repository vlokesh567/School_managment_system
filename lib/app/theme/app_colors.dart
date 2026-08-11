import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary Colors
  static const Color primary = Color(0xFF2563EB);
  static const Color primaryLight = Color(0xFF60A5FA);
  static const Color primaryDark = Color(0xFF1D4ED8);

  // Secondary Colors
  static const Color secondary = Color(0xFF0EA5E9);
  static const Color secondaryLight = Color(0xFF7DD3FC);
  static const Color secondaryDark = Color(0xFF0369A1);

  // Accent Colors
  static const Color accent = Color(0xFF8B5CF6);
  static const Color accentLight = Color(0xFFA78BFA);
  static const Color accentDark = Color(0xFF6D28D9);

  // Status Colors
  static const Color success = Color(0xFF10B981);
  static const Color successLight = Color(0xFFA7F3D0);
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningLight = Color(0xFFFDE68A);
  static const Color danger = Color(0xFFEF4444);
  static const Color dangerLight = Color(0xFFFCA5A5);
  static const Color info = Color(0xFF3B82F6);
  static const Color infoLight = Color(0xFF93C5FD);

  // Neutral Colors - Light
  static const Color background = Color(0xFFF8FAFC);
  static const Color surface = Colors.white;
  static const Color cardLight = Colors.white;
  static const Color borderLight = Color(0xFFE2E8F0);
  static const Color dividerLight = Color(0xFFF1F5F9);

  // Neutral Colors - Dark
  static const Color backgroundDark = Color(0xFF0F172A);
  static const Color surfaceDark = Color(0xFF1E293B);
  static const Color cardDark = Color(0xFF1E293B);
  static const Color borderDark = Color(0xFF334155);
  static const Color dividerDark = Color(0xFF1E293B);

  // Text Colors
  static const Color textPrimary = Color(0xFF111827);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textTertiary = Color(0xFF9CA3AF);
  static const Color textInverse = Colors.white;

  // Text Colors - Dark
  static const Color textPrimaryDark = Color(0xFFF1F5F9);
  static const Color textSecondaryDark = Color(0xFF94A3B8);
  static const Color textTertiaryDark = Color(0xFF64748B);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryDark],
  );

  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [accent, primary],
  );

  static const LinearGradient successGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [success, Color(0xFF059669)],
  );

  static const LinearGradient sunsetGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [warning, Color(0xFFEA580C)],
  );

  // Shadows
  static List<BoxShadow> softShadow = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.05),
      blurRadius: 10,
      offset: const Offset(0, 2),
    ),
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.02),
      blurRadius: 20,
      offset: const Offset(0, 6),
    ),
  ];

  static List<BoxShadow> mediumShadow = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.08),
      blurRadius: 15,
      offset: const Offset(0, 4),
    ),
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.04),
      blurRadius: 30,
      offset: const Offset(0, 10),
    ),
  ];

  static List<BoxShadow> strongShadow = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.12),
      blurRadius: 20,
      offset: const Offset(0, 6),
    ),
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.06),
      blurRadius: 40,
      offset: const Offset(0, 15),
    ),
  ];

  // Role Colors
  static const Color superAdminColor = Color(0xFF7C3AED);
  static const Color schoolAdminColor = Color(0xFF2563EB);
  static const Color teacherColor = Color(0xFF059669);
  static const Color parentColor = Color(0xFFD97706);
  static const Color studentColor = Color(0xFFDC2626);
  static const Color driverColor = Color(0xFF0891B2);

  // Subject Colors
  static const Color mathColor = Color(0xFFEF4444);
  static const Color scienceColor = Color(0xFF10B981);
  static const Color englishColor = Color(0xFF3B82F6);
  static const Color historyColor = Color(0xFFF59E0B);
  static const Color geographyColor = Color(0xFF8B5CF6);
  static const Color artColor = Color(0xFFEC4899);
  static const Color sportsColor = Color(0xFF14B8A6);
}
