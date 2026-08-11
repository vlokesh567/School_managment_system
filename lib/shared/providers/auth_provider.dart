import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';
import '../../core/storage/local_storage.dart';
import '../../core/utils/constants.dart';

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>(
  (ref) => AuthNotifier(),
);

class AuthState {
  final UserModel? user;
  final bool isLoading;
  final bool isAuthenticated;

  const AuthState({
    this.user,
    this.isLoading = false,
    this.isAuthenticated = false,
  });

  AuthState copyWith({
    UserModel? user,
    bool? isLoading,
    bool? isAuthenticated,
  }) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(const AuthState());

  /// Mock login — simulates backend auth and returns role-specific user
  Future<void> login(String phone, String password) async {
    state = state.copyWith(isLoading: true);
    await Future.delayed(const Duration(milliseconds: 800));

    // Mock user lookup based on phone number
    // In production this would be an API call
    UserModel user;
    if (phone == '9876543210') {
      user = UserModel(
        id: '1',
        name: 'Admin User',
        email: 'admin@springdale.edu',
        phone: phone,
        role: UserRole.schoolAdmin,
        schoolId: 'SCH001',
        schoolName: 'Springdale International School',
      );
    } else if (phone == '9876543211') {
      user = UserModel(
        id: '2',
        name: 'Mrs. Ananya Sharma',
        email: 'ananya@springdale.edu',
        phone: phone,
        role: UserRole.teacher,
        schoolId: 'SCH001',
        schoolName: 'Springdale International School',
      );
    } else if (phone == '9876543212') {
      user = UserModel(
        id: '3',
        name: 'Rajesh Sharma',
        email: 'rajesh@email.com',
        phone: phone,
        role: UserRole.parent,
        schoolId: 'SCH001',
        schoolName: 'Springdale International School',
        parentId: 'P001',
      );
    } else if (phone == '9876543213') {
      user = UserModel(
        id: '4',
        name: 'Priya Sharma',
        email: 'priya.s@student.edu',
        phone: phone,
        role: UserRole.student,
        schoolId: 'SCH001',
        schoolName: 'Springdale International School',
        classId: '10A',
        section: 'A',
        rollNumber: '101',
        parentId: 'P001',
      );
    } else if (phone == '9876543214') {
      user = UserModel(
        id: '5',
        name: 'Rajesh Kumar',
        email: 'rajesh.k@transport.com',
        phone: phone,
        role: UserRole.driver,
        schoolId: 'SCH001',
        schoolName: 'Springdale International School',
      );
    } else if (phone == '9999999999') {
      user = UserModel(
        id: '0',
        name: 'Super Admin',
        email: 'super@schoolerp.com',
        phone: phone,
        role: UserRole.superAdmin,
      );
    } else {
      // Default: treat as school admin
      user = UserModel(
        id: '1',
        name: 'Admin User',
        email: 'admin@springdale.edu',
        phone: phone,
        role: UserRole.schoolAdmin,
        schoolId: 'SCH001',
        schoolName: 'Springdale International School',
      );
    }

    // Persist session
    await LocalStorage.setString(AppConstants.tokenKey, 'mock_token_${user.id}');
    await LocalStorage.setString(AppConstants.userKey, user.role.key);

    state = AuthState(user: user, isAuthenticated: true, isLoading: false);
  }

  /// Restore session from stored data
  Future<void> restoreSession() async {
    final roleKey = LocalStorage.getString(AppConstants.userKey);
    final token = LocalStorage.getString(AppConstants.tokenKey);

    if (roleKey == null || token == null) {
      state = const AuthState();
      return;
    }

    final role = UserRole.fromKey(roleKey);

    // Rebuild a minimal user from stored role
    UserModel user;
    switch (role) {
      case UserRole.superAdmin:
        user = UserModel(
          id: '0',
          name: 'Super Admin',
          email: 'super@schoolerp.com',
          phone: '9999999999',
          role: UserRole.superAdmin,
        );
      case UserRole.schoolAdmin:
        user = UserModel(
          id: '1',
          name: 'Admin User',
          email: 'admin@springdale.edu',
          phone: '9876543210',
          role: UserRole.schoolAdmin,
          schoolId: 'SCH001',
          schoolName: 'Springdale International School',
        );
      case UserRole.teacher:
        user = UserModel(
          id: '2',
          name: 'Mrs. Ananya Sharma',
          email: 'ananya@springdale.edu',
          phone: '9876543211',
          role: UserRole.teacher,
          schoolId: 'SCH001',
          schoolName: 'Springdale International School',
        );
      case UserRole.parent:
        user = UserModel(
          id: '3',
          name: 'Rajesh Sharma',
          email: 'rajesh@email.com',
          phone: '9876543212',
          role: UserRole.parent,
          schoolId: 'SCH001',
          schoolName: 'Springdale International School',
        );
      case UserRole.student:
        user = UserModel(
          id: '4',
          name: 'Priya Sharma',
          email: 'priya.s@student.edu',
          phone: '9876543213',
          role: UserRole.student,
          schoolId: 'SCH001',
          schoolName: 'Springdale International School',
          classId: '10A',
        );
      case UserRole.driver:
        user = UserModel(
          id: '5',
          name: 'Rajesh Kumar',
          email: 'rajesh.k@transport.com',
          phone: '9876543214',
          role: UserRole.driver,
          schoolId: 'SCH001',
          schoolName: 'Springdale International School',
        );
    }

    state = AuthState(user: user, isAuthenticated: true);
  }

  Future<void> logout() async {
    await LocalStorage.remove(AppConstants.tokenKey);
    await LocalStorage.remove(AppConstants.userKey);
    state = const AuthState();
  }
}
