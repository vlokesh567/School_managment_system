import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app/theme/app_theme.dart';
import 'app/routes/app_router.dart';
import 'shared/providers/theme_provider.dart';
import 'core/storage/local_storage.dart';
import 'core/storage/hive_storage.dart';
import 'core/network/connectivity_service.dart';
import 'core/sync/sync_service.dart';
import 'core/sync/offline_queue.dart';
import 'core/sync/sync_provider.dart';
import 'core/services/firebase_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 🧪 Demo mode — skips all real HTTP calls, uses mock data.
  // Set ApiClient.isDemo = false when connecting to a real backend.
  // ApiClient.isDemo = true; // (already the default)

  await LocalStorage.init();
  await HiveStorage.init();
  await ConnectivityService.instance.start();
  // Initialize Firebase (graceful fallback if not configured)
  await FirebaseService.instance.init();
  // Log analytics event on app start
  FirebaseService.instance.logEvent('app_started');
  _registerSyncProcessors();
  SyncService.instance.start();
  runApp(
    ProviderScope(
      child: _SyncWire(child: const SchoolApp()),
    ),
  );
}

/// Wires sync notifiers once the provider scope is available.
class _SyncWire extends ConsumerWidget {
  final Widget child;
  const _SyncWire({required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Attach the state notifier + count notifier to SyncService
    SyncService.instance.attachNotifiers(
      ref.read(syncStateProvider.notifier),
      ref.read(pendingQueueCountProvider.notifier),
    );
    // Wire queue change callback so the badge updates reactively
    OfflineQueue.onQueueChanged = () {
      ref.read(pendingQueueCountProvider.notifier).refresh();
    };
    return child;
  }
}

/// Register processors for each feature so queued mutations can be replayed.
void _registerSyncProcessors() {
  // Attendance marks
  SyncService.instance.registerProcessor('attendance', (mutation) async {
    // In production, replay the API call:
    // final repo = AttendanceRepository();
    // await repo.markAttendance(payload);
    debugPrint('[Sync] Replaying attendance: ${mutation.payload}');
    await Future.delayed(const Duration(milliseconds: 200));
    return true;
  });

  // Homework creation
  SyncService.instance.registerProcessor('homework', (mutation) async {
    debugPrint('[Sync] Replaying homework: ${mutation.payload}');
    await Future.delayed(const Duration(milliseconds: 200));
    return true;
  });

  // Fee collection
  SyncService.instance.registerProcessor('fees', (mutation) async {
    debugPrint('[Sync] Replaying fee: ${mutation.payload}');
    await Future.delayed(const Duration(milliseconds: 200));
    return true;
  });
}

class SchoolApp extends ConsumerWidget {
  const SchoolApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final router = buildRouter(ref);

    return MaterialApp.router(
      title: 'School ERP',
      debugShowCheckedModeBanner: false,

      // Theme
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode == ThemeMode.dark ? ThemeMode.dark : ThemeMode.light,

      // Localization
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''),
        Locale('hi', ''),
        Locale('te', ''),
        Locale('ta', ''),
        Locale('kn', ''),
      ],
      locale: const Locale('en'),

      // GoRouter
      routerConfig: router,
    );
  }
}
