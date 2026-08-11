enum AttendanceStatus { present, absent, late }

extension AttendanceStatusX on AttendanceStatus {
  String get label {
    switch (this) {
      case AttendanceStatus.present:
        return 'Present';
      case AttendanceStatus.absent:
        return 'Absent';
      case AttendanceStatus.late:
        return 'Late';
    }
  }

  static AttendanceStatus fromString(String s) {
    switch (s.toLowerCase()) {
      case 'present':
        return AttendanceStatus.present;
      case 'absent':
        return AttendanceStatus.absent;
      case 'late':
        return AttendanceStatus.late;
      default:
        return AttendanceStatus.present;
    }
  }
}

class AttendanceRecord {
  final String id;
  final String studentId;
  final String studentName;
  final String studentClass;
  final AttendanceStatus status;
  final String time;
  final String date;
  final String? schoolId;

  AttendanceRecord({
    required this.id,
    required this.studentId,
    required this.studentName,
    required this.studentClass,
    this.status = AttendanceStatus.present,
    this.time = '',
    this.date = '',
    this.schoolId,
  });

  factory AttendanceRecord.fromJson(Map<String, dynamic> json) {
    return AttendanceRecord(
      id: json['id']?.toString() ?? '',
      studentId: json['student_id']?.toString() ?? '',
      studentName: json['student_name'] as String? ?? '',
      studentClass: json['class'] as String? ?? '',
      status: AttendanceStatusX.fromString(json['status'] as String? ?? 'Present'),
      time: json['time'] as String? ?? '',
      date: json['date'] as String? ?? '',
      schoolId: json['school_id'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'student_id': studentId,
        'student_name': studentName,
        'class': studentClass,
        'status': status.label,
        'time': time,
        'date': date,
        'school_id': schoolId,
      };
}
