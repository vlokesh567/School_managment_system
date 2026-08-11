class TeacherModel {
  final String id;
  final String firstName;
  final String lastName;
  final String? photoUrl;
  final String subjects;
  final String assignedClasses;
  final int studentCount;
  final String? phone;
  final String? email;
  final String? qualification;
  final String? address;
  final String? schoolId;

  TeacherModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.photoUrl,
    this.subjects = '',
    this.assignedClasses = '',
    this.studentCount = 0,
    this.phone,
    this.email,
    this.qualification,
    this.address,
    this.schoolId,
  });

  String get fullName => '$firstName $lastName';
  String get initials =>
      '${firstName.isNotEmpty ? firstName[0] : ''}${lastName.isNotEmpty ? lastName[0] : ''}';

  factory TeacherModel.fromJson(Map<String, dynamic> json) {
    return TeacherModel(
      id: json['id']?.toString() ?? '',
      firstName: json['first_name'] as String? ?? '',
      lastName: json['last_name'] as String? ?? '',
      photoUrl: json['photo_url'] as String?,
      subjects: json['subjects'] as String? ?? '',
      assignedClasses: json['assigned_classes'] as String? ?? '',
      studentCount: (json['student_count'] as num?)?.toInt() ?? 0,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      qualification: json['qualification'] as String?,
      address: json['address'] as String?,
      schoolId: json['school_id'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'first_name': firstName,
        'last_name': lastName,
        'photo_url': photoUrl,
        'subjects': subjects,
        'assigned_classes': assignedClasses,
        'student_count': studentCount,
        'phone': phone,
        'email': email,
        'qualification': qualification,
        'address': address,
        'school_id': schoolId,
      };
}
