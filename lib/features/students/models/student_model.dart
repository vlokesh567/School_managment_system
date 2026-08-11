class StudentModel {
  final String id;
  final String firstName;
  final String lastName;
  final String? photoUrl;
  final String studentClass;
  final String section;
  final String rollNumber;
  final double attendancePercent;
  final String? dateOfBirth;
  final String? gender;
  final String? bloodGroup;
  final String? address;
  final String? phone;
  final String? email;
  final String? admissionNo;
  final String? admissionDate;
  final String? previousSchool;
  final String? transportRoute;
  final String? fatherName;
  final String? motherName;
  final String? parentContact;
  final String? parentEmail;
  final String? allergies;
  final String? medicalConditions;
  final String? emergencyContact;
  final String? schoolId;

  StudentModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.photoUrl,
    required this.studentClass,
    this.section = '',
    required this.rollNumber,
    this.attendancePercent = 0,
    this.dateOfBirth,
    this.gender,
    this.bloodGroup,
    this.address,
    this.phone,
    this.email,
    this.admissionNo,
    this.admissionDate,
    this.previousSchool,
    this.transportRoute,
    this.fatherName,
    this.motherName,
    this.parentContact,
    this.parentEmail,
    this.allergies,
    this.medicalConditions,
    this.emergencyContact,
    this.schoolId,
  });

  String get fullName => '$firstName $lastName';
  String get initials =>
      '${firstName.isNotEmpty ? firstName[0] : ''}${lastName.isNotEmpty ? lastName[0] : ''}';

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
      id: json['id']?.toString() ?? '',
      firstName: json['first_name'] as String? ?? '',
      lastName: json['last_name'] as String? ?? '',
      photoUrl: json['photo_url'] as String?,
      studentClass: json['class'] as String? ?? '',
      section: json['section'] as String? ?? '',
      rollNumber: json['roll_number']?.toString() ?? '',
      attendancePercent: (json['attendance_percent'] as num?)?.toDouble() ?? 0,
      dateOfBirth: json['date_of_birth'] as String?,
      gender: json['gender'] as String?,
      bloodGroup: json['blood_group'] as String?,
      address: json['address'] as String?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      admissionNo: json['admission_no'] as String?,
      admissionDate: json['admission_date'] as String?,
      previousSchool: json['previous_school'] as String?,
      transportRoute: json['transport_route'] as String?,
      fatherName: json['father_name'] as String?,
      motherName: json['mother_name'] as String?,
      parentContact: json['parent_contact'] as String?,
      parentEmail: json['parent_email'] as String?,
      allergies: json['allergies'] as String?,
      medicalConditions: json['medical_conditions'] as String?,
      emergencyContact: json['emergency_contact'] as String?,
      schoolId: json['school_id'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'first_name': firstName,
        'last_name': lastName,
        'photo_url': photoUrl,
        'class': studentClass,
        'section': section,
        'roll_number': rollNumber,
        'attendance_percent': attendancePercent,
        'date_of_birth': dateOfBirth,
        'gender': gender,
        'blood_group': bloodGroup,
        'address': address,
        'phone': phone,
        'email': email,
        'admission_no': admissionNo,
        'admission_date': admissionDate,
        'previous_school': previousSchool,
        'transport_route': transportRoute,
        'father_name': fatherName,
        'mother_name': motherName,
        'parent_contact': parentContact,
        'parent_email': parentEmail,
        'allergies': allergies,
        'medical_conditions': medicalConditions,
        'emergency_contact': emergencyContact,
        'school_id': schoolId,
      };
}
