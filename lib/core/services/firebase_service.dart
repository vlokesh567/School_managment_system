import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

/// Lightweight wrapper around Firebase services that handles the
/// case where Firebase has not been configured (no google-services.json /
/// GoogleService-Info.plist) gracefully — the app should not crash.
class FirebaseService {
  static FirebaseService? _instance;
  bool _initialized = false;
  bool _available = false;

  FirebaseMessaging? _messaging;
  FirebaseAnalytics? _analytics;

  FirebaseService._();

  static FirebaseService get instance {
    _instance ??= FirebaseService._();
    return _instance!;
  }

  /// Whether Firebase is available (initialized successfully).
  bool get isAvailable => _available;

  /// Whether the service has been initialized.
  bool get isInitialized => _initialized;

  /// Initialize Firebase. Call once at app startup.
  /// Catches exceptions gracefully when configuration files are missing.
  Future<void> init() async {
    if (_initialized) return;
    _initialized = true;

    try {
      // Use auto-detection from google-services.json / GoogleService-Info.plist
      await Firebase.initializeApp();
      _messaging = FirebaseMessaging.instance;
      _analytics = FirebaseAnalytics.instance;
      _available = true;

      // Request notification permissions
      await _requestPermission();

      // Get FCM token
      final token = await _messaging!.getToken();
      debugPrint('[Firebase] FCM token: $token');

      // Listen for token refresh
      _messaging!.onTokenRefresh.listen((newToken) {
        debugPrint('[Firebase] FCM token refreshed: $newToken');
        // In production: send new token to your backend
      });

      // Handle foreground messages
      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

      debugPrint('[Firebase] Initialized successfully');
    } catch (e) {
      _available = false;
      debugPrint('[Firebase] Not available: $e');
      // Non-fatal — app continues without Firebase features
    }
  }

  Future<void> _requestPermission() async {
    if (_messaging == null) return;
    final settings = await _messaging!.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    debugPrint('[Firebase] Notification permission: ${settings.authorizationStatus}');
  }

  void _handleForegroundMessage(RemoteMessage message) {
    debugPrint('[Firebase] Foreground message: ${message.notification?.title}');
    // In production: show an in-app notification banner
  }

  /// Log a Firebase Analytics event.
  void logEvent(String name, {Map<String, Object>? parameters}) {
    if (!_available || _analytics == null) return;
    _analytics!.logEvent(name: name, parameters: parameters);
  }

  /// Log a screen view.
  void logScreenView(String screenName, String screenClass) {
    if (!_available || _analytics == null) return;
    _analytics!.logScreenView(
      screenName: screenName,
      screenClass: screenClass,
    );
  }

  /// Set user properties for analytics (e.g., role, school).
  void setUserProperty(String name, String value) {
    if (!_available || _analytics == null) return;
    _analytics!.setUserProperty(name: name, value: value);
  }
}
