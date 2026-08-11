enum UserRole {
  superAdmin,
  schoolAdmin,
  teacher,
  parent,
  student,
  driver;

  String get label {
    switch (this) {
      case UserRole.superAdmin:
        return 'Super Admin';
      case UserRole.schoolAdmin:
        return 'School Admin';
      case UserRole.teacher:
        return 'Teacher';
      case UserRole.parent:
        return 'Parent';
      case UserRole.student:
        return 'Student';
      case UserRole.driver:
        return 'Driver';
    }
  }

  String get key {
    switch (this) {
      case UserRole.superAdmin:
        return 'super_admin';
      case UserRole.schoolAdmin:
        return 'school_admin';
      case UserRole.teacher:
        return 'teacher';
      case UserRole.parent:
        return 'parent';
      case UserRole.student:
        return 'student';
      case UserRole.driver:
        return 'driver';
    }
  }

  static UserRole fromKey(String key) {
    return UserRole.values.firstWhere(
      (role) => role.key == key,
      orElse: () => UserRole.student,
    );
  }
}

class UserModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final UserRole role;
  final String? schoolId;
  final String? schoolName;
  final String? profileImage;
  final String? classId;
  final String? section;
  final String? rollNumber;
  final String? parentId;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    this.schoolId,
    this.schoolName,
    this.profileImage,
    this.classId,
    this.section,
    this.rollNumber,
    this.parentId,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String,
      role: UserRole.fromKey(json['role'] as String),
      schoolId: json['school_id'] as String?,
      schoolName: json['school_name'] as String?,
      profileImage: json['profile_image'] as String?,
      classId: json['class_id'] as String?,
      section: json['section'] as String?,
      rollNumber: json['roll_number'] as String?,
      parentId: json['parent_id'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'role': role.key,
      'school_id': schoolId,
      'school_name': schoolName,
      'profile_image': profileImage,
      'class_id': classId,
      'section': section,
      'roll_number': rollNumber,
      'parent_id': parentId,
    };
  }
}
