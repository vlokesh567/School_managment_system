/// Centralized API endpoint paths for the School ERP backend.
/// Base URL is configured in [ApiClient].
class ApiEndpoints {
  ApiEndpoints._();

  // -- Auth --
  static const String login = '/auth/login';
  static const String logout = '/auth/logout';
  static const String refreshToken = '/auth/refresh';
  static const String forgotPassword = '/auth/forgot-password';
  static const String verifyOtp = '/auth/verify-otp';

  // -- Students --
  static const String students = '/students';
  static String studentById(String id) => '/students/$id';

  // -- Teachers --
  static const String teachers = '/teachers';
  static String teacherById(String id) => '/teachers/$id';

  // -- Attendance --
  static const String attendance = '/attendance';
  static String attendanceByDate(String date) => '/attendance/date/$date';
  static String attendanceByStudent(String studentId) =>
      '/attendance/student/$studentId';

  // -- Homework --
  static const String homework = '/homework';
  static String homeworkById(String id) => '/homework/$id';

  // -- Exams --
  static const String exams = '/exams';
  static String examById(String id) => '/exams/$id';
  static const String marksEntry = '/exams/marks';

  // -- Fees --
  static const String fees = '/fees';
  static const String feeTransactions = '/fees/transactions';
  static String feeByStudent(String studentId) => '/fees/student/$studentId';

  // -- Transport --
  static const String transportRoutes = '/transport/routes';
  static String transportRouteById(String id) => '/transport/routes/$id';
  static const String transportVehicles = '/transport/vehicles';
  static const String liveTracking = '/transport/live';

  // -- Events --
  static const String events = '/events';

  // -- Notifications --
  static const String notifications = '/notifications';
  static const String markNotificationRead = '/notifications/mark-read';

  // -- Timetable --
  static const String timetable = '/timetable';
  static String timetableByClass(String classId) => '/timetable/class/$classId';

  // -- Dashboard --
  static const String dashboardStats = '/dashboard/stats';
  static const String dashboardActivities = '/dashboard/activities';
}
