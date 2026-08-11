class AppConstants {
  AppConstants._();

  static const String appName = 'School ERP';
  static const String appVersion = '1.0.0';
  static const String baseUrl = 'https://api.schoolerp.com/v1';
  static const Duration apiTimeout = Duration(seconds: 30);

  static const String tokenKey = 'auth_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userKey = 'user_data';
  static const String themeKey = 'theme_mode';
  static const String localeKey = 'locale';
  static const String onboardingKey = 'onboarding_complete';

  static const int defaultPageSize = 20;
  static const Duration defaultAnimationDuration = Duration(milliseconds: 300);
  static const double defaultPadding = 20.0;
  static const double cardRadius = 20.0;
  static const double buttonRadius = 16.0;
}
