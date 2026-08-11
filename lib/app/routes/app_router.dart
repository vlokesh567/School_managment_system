import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../shared/models/user_model.dart';
import '../../shared/providers/auth_provider.dart';
import '../../core/services/firebase_service.dart';
import '../../features/splash/splash_screen.dart';
import '../../features/auth/screens/onboarding_screen.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/otp_screen.dart';
import '../../features/auth/screens/forgot_password_screen.dart';
import '../../features/dashboard/screens/dashboard_shell.dart';
import '../../features/dashboard/screens/admin_dashboard.dart';
import '../../features/dashboard/screens/teacher_dashboard.dart';
import '../../features/dashboard/screens/parent_dashboard.dart';
import '../../features/dashboard/screens/student_dashboard.dart';
import '../../features/dashboard/screens/driver_dashboard.dart';
import '../../features/dashboard/screens/super_admin_dashboard.dart';
import '../../features/students/screens/student_list_screen.dart';
import '../../features/students/screens/student_detail_screen.dart';
import '../../features/students/screens/add_student_screen.dart';
import '../../features/teachers/screens/teacher_list_screen.dart';
import '../../features/teachers/screens/teacher_detail_screen.dart';
import '../../features/teachers/screens/add_teacher_screen.dart';
import '../../features/attendance/screens/attendance_list_screen.dart';
import '../../features/attendance/screens/mark_attendance_screen.dart';
import '../../features/homework/screens/homework_list_screen.dart';
import '../../features/homework/screens/create_homework_screen.dart';
import '../../features/homework/screens/homework_detail_screen.dart';
import '../../features/exams/screens/exam_list_screen.dart';
import '../../features/exams/screens/marks_entry_screen.dart';
import '../../features/fees/screens/fee_dashboard_screen.dart';
import '../../features/fees/screens/collect_fee_screen.dart';
import '../../features/fees/screens/fee_reports_screen.dart';
import '../../features/transport/screens/transport_dashboard_screen.dart';
import '../../features/transport/screens/live_tracking_map_screen.dart';
import '../../features/events/screens/events_list_screen.dart';
import '../../features/notifications/screens/notifications_list_screen.dart';
import '../../features/timetable/screens/timetable_screen.dart';
import '../../features/settings/screens/settings_screen.dart';
import '../../features/settings/screens/profile_screen.dart';

/// Route path constants
class AppRoutes {
  AppRoutes._();

  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String otp = '/login/otp';
  static const String forgotPassword = '/forgot-password';
  static const String dashboard = '/dashboard';
  static const String students = '/dashboard/students';
  static const String addStudent = '/dashboard/students/add';
  static const String studentDetail = '/dashboard/students/:id';
  static const String teachers = '/dashboard/teachers';
  static const String teacherDetail = '/dashboard/teachers/:id';
  static const String addTeacher = '/dashboard/teachers/add';
  static const String attendance = '/dashboard/attendance';
  static const String markAttendance = '/dashboard/attendance/mark';
  static const String homework = '/dashboard/homework';
  static const String homeworkDetail = '/dashboard/homework/:id';
  static const String createHomework = '/dashboard/homework/create';
  static const String exams = '/dashboard/exams';
  static const String marksEntry = '/dashboard/exams/marks';
  static const String fees = '/dashboard/fees';
  static const String collectFee = '/dashboard/fees/collect';
  static const String feeReports = '/dashboard/fees/reports';
  static const String transport = '/dashboard/transport';
  static const String liveTracking = '/dashboard/transport/live';
  static const String events = '/dashboard/events';
  static const String notificationsScreen = '/dashboard/notifications';
  static const String timetable = '/dashboard/timetable';
  static const String settings = '/dashboard/settings';
  static const String profile = '/dashboard/profile';
}

/// Builds the GoRouter with auth guard and role-based routing.
GoRouter buildRouter(WidgetRef ref) {
  final router = GoRouter(
    initialLocation: AppRoutes.splash,

    // Redirect: protect dashboard routes, skip splash if logged in.
    // Also logs screen views to Firebase Analytics.
    redirect: (context, state) {
      // Log screen view on every route change
      FirebaseService.instance.logScreenView(
        state.uri.toString(),
        'GoRoute',
      );

      final authState = ref.read(authProvider);
      final isLoggedIn = authState.isAuthenticated;
      final path = state.uri.path;

      // Public routes always allowed - skip redirect for auth/splash pages
      // Protect dashboard routes
      if (!isLoggedIn && path.startsWith('/dashboard')) {
        return AppRoutes.login;
      }

      // If logged in and on auth/splash pages, go to dashboard
      if (isLoggedIn && (path == AppRoutes.splash || path == AppRoutes.login || path == AppRoutes.onboarding)) {
        return AppRoutes.dashboard;
      }

      return null; // no redirect
    },

    routes: [
      // Splash
      GoRoute(path: AppRoutes.splash, builder: (_, __) => const SplashScreen()),

      // Auth
      GoRoute(path: AppRoutes.onboarding, builder: (_, __) => const OnboardingScreen()),
      GoRoute(path: AppRoutes.login, builder: (_, __) => const LoginScreen()),
      GoRoute(path: AppRoutes.otp, builder: (_, __) => const OtpScreen()),
      GoRoute(path: AppRoutes.forgotPassword, builder: (_, __) => const ForgotPasswordScreen()),

      // Dashboard shell (role-based, nested bottom nav)
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          final role = ref.read(authProvider).user?.role ?? UserRole.schoolAdmin;
          return DashboardShell(role: role, navigationShell: navigationShell);
        },
        branches: _dashboardBranches(ref),
      ),

      // Standalone feature screens
      GoRoute(path: AppRoutes.students, builder: (_, __) => const StudentListScreen()),
      GoRoute(path: AppRoutes.studentDetail, builder: (_, state) => StudentDetailScreen(studentId: state.pathParameters['id']!)),
      GoRoute(path: AppRoutes.addStudent, builder: (_, __) => const AddStudentScreen()),
      GoRoute(path: AppRoutes.teachers, builder: (_, __) => const TeacherListScreen()),
      GoRoute(path: AppRoutes.teacherDetail, builder: (_, state) => TeacherDetailScreen(teacherId: state.pathParameters['id']!)),
      GoRoute(path: AppRoutes.addTeacher, builder: (_, __) => const AddTeacherScreen()),
      GoRoute(path: AppRoutes.attendance, builder: (_, __) => const AttendanceListScreen()),
      GoRoute(path: AppRoutes.markAttendance, builder: (_, __) => const MarkAttendanceScreen()),
      GoRoute(path: AppRoutes.homework, builder: (_, __) => const HomeworkListScreen()),
      GoRoute(path: AppRoutes.homeworkDetail, builder: (_, state) => HomeworkDetailScreen(homeworkId: state.pathParameters['id']!)),
      GoRoute(path: AppRoutes.createHomework, builder: (_, __) => const CreateHomeworkScreen()),
      GoRoute(path: AppRoutes.exams, builder: (_, __) => const ExamListScreen()),
      GoRoute(path: AppRoutes.marksEntry, builder: (_, __) => const MarksEntryScreen()),
      GoRoute(path: AppRoutes.fees, builder: (_, __) => const FeeDashboardScreen()),
      GoRoute(path: AppRoutes.collectFee, builder: (_, __) => const CollectFeeScreen()),
      GoRoute(path: AppRoutes.feeReports, builder: (_, __) => const FeeReportsScreen()),
      GoRoute(path: AppRoutes.transport, builder: (_, __) => const TransportDashboardScreen()),
      GoRoute(path: AppRoutes.liveTracking, builder: (_, __) => const LiveTrackingMapScreen()),
      GoRoute(path: AppRoutes.events, builder: (_, __) => const EventsListScreen()),
      GoRoute(path: AppRoutes.notificationsScreen, builder: (_, __) => const NotificationsListScreen()),
      GoRoute(path: AppRoutes.timetable, builder: (_, __) => const TimetableScreen()),
      GoRoute(path: AppRoutes.settings, builder: (_, __) => const SettingsScreen()),
      GoRoute(path: AppRoutes.profile, builder: (_, __) => const ProfileScreen()),
    ],
  );
  return router;
}

/// Returns role-appropriate StatefulShellRoute branches.
List<StatefulShellBranch> _dashboardBranches(WidgetRef ref) {
  final role = ref.read(authProvider).user?.role ?? UserRole.schoolAdmin;

  switch (role) {
    case UserRole.schoolAdmin:
      return [
        StatefulShellBranch(routes: [GoRoute(path: '/dashboard', builder: (_, __) => const AdminDashboard())]),
        StatefulShellBranch(routes: [GoRoute(path: AppRoutes.students, builder: (_, __) => const StudentListScreen())]),
        StatefulShellBranch(routes: [GoRoute(path: AppRoutes.homework, builder: (_, __) => const HomeworkListScreen())]),
        StatefulShellBranch(routes: [GoRoute(path: AppRoutes.notificationsScreen, builder: (_, __) => const NotificationsListScreen())]),
        StatefulShellBranch(routes: [GoRoute(path: AppRoutes.settings, builder: (_, __) => const SettingsScreen())]),
      ];
    case UserRole.teacher:
      return [
        StatefulShellBranch(routes: [GoRoute(path: '/dashboard', builder: (_, __) => const TeacherDashboard())]),
        StatefulShellBranch(routes: [GoRoute(path: AppRoutes.attendance, builder: (_, __) => const AttendanceListScreen())]),
        StatefulShellBranch(routes: [GoRoute(path: AppRoutes.homework, builder: (_, __) => const HomeworkListScreen())]),
        StatefulShellBranch(routes: [GoRoute(path: AppRoutes.timetable, builder: (_, __) => const TimetableScreen())]),
        StatefulShellBranch(routes: [GoRoute(path: AppRoutes.settings, builder: (_, __) => const SettingsScreen())]),
      ];
    case UserRole.parent:
      return [
        StatefulShellBranch(routes: [GoRoute(path: '/dashboard', builder: (_, __) => const ParentDashboard())]),
        StatefulShellBranch(routes: [GoRoute(path: AppRoutes.homework, builder: (_, __) => const HomeworkListScreen())]),
        StatefulShellBranch(routes: [GoRoute(path: AppRoutes.fees, builder: (_, __) => const FeeDashboardScreen())]),
        StatefulShellBranch(routes: [GoRoute(path: AppRoutes.transport, builder: (_, __) => const TransportDashboardScreen())]),
        StatefulShellBranch(routes: [GoRoute(path: AppRoutes.settings, builder: (_, __) => const SettingsScreen())]),
      ];
    case UserRole.student:
      return [
        StatefulShellBranch(routes: [GoRoute(path: '/dashboard', builder: (_, __) => const StudentDashboard())]),
        StatefulShellBranch(routes: [GoRoute(path: AppRoutes.homework, builder: (_, __) => const HomeworkListScreen())]),
        StatefulShellBranch(routes: [GoRoute(path: AppRoutes.exams, builder: (_, __) => const ExamListScreen())]),
        StatefulShellBranch(routes: [GoRoute(path: AppRoutes.timetable, builder: (_, __) => const TimetableScreen())]),
        StatefulShellBranch(routes: [GoRoute(path: AppRoutes.settings, builder: (_, __) => const SettingsScreen())]),
      ];
    case UserRole.driver:
      return [
        StatefulShellBranch(routes: [GoRoute(path: '/dashboard', builder: (_, __) => const DriverDashboard())]),
        StatefulShellBranch(routes: [GoRoute(path: AppRoutes.transport, builder: (_, __) => const TransportDashboardScreen())]),
        StatefulShellBranch(routes: [GoRoute(path: AppRoutes.students, builder: (_, __) => const StudentListScreen())]),
        StatefulShellBranch(routes: [GoRoute(path: AppRoutes.notificationsScreen, builder: (_, __) => const NotificationsListScreen())]),
        StatefulShellBranch(routes: [GoRoute(path: AppRoutes.settings, builder: (_, __) => const SettingsScreen())]),
      ];
    case UserRole.superAdmin:
      return [
        StatefulShellBranch(routes: [GoRoute(path: '/dashboard', builder: (_, __) => const SuperAdminDashboard())]),
        StatefulShellBranch(routes: [GoRoute(path: AppRoutes.students, builder: (_, __) => const StudentListScreen())]),
        StatefulShellBranch(routes: [GoRoute(path: AppRoutes.fees, builder: (_, __) => const FeeDashboardScreen())]),
        StatefulShellBranch(routes: [GoRoute(path: AppRoutes.settings, builder: (_, __) => const SettingsScreen())]),
      ];
  }
}
