class TransportRoute {
  final String id;
  final String name;
  final String driverName;
  final String vehicleNumber;
  final String status; // On Time, Delayed
  final int studentCount;
  final String? vehicleType;

  TransportRoute({
    required this.id,
    required this.name,
    this.driverName = '',
    this.vehicleNumber = '',
    this.status = 'On Time',
    this.studentCount = 0,
    this.vehicleType,
  });

  bool get isDelayed => status == 'Delayed';

  factory TransportRoute.fromJson(Map<String, dynamic> json) {
    return TransportRoute(
      id: json['id']?.toString() ?? '',
      name: json['name'] as String? ?? '',
      driverName: json['driver_name'] as String? ?? '',
      vehicleNumber: json['vehicle_number'] as String? ?? '',
      status: json['status'] as String? ?? 'On Time',
      studentCount: (json['student_count'] as num?)?.toInt() ?? 0,
      vehicleType: json['vehicle_type'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'driver_name': driverName,
        'vehicle_number': vehicleNumber,
        'status': status,
        'student_count': studentCount,
        'vehicle_type': vehicleType,
      };
}

class LiveTrackingInfo {
  final String busId;
  final String routeName;
  final String driverName;
  final String status; // Moving, Stopped, Idle
  final double? latitude;
  final double? longitude;
  final List<BusStop> stops;

  LiveTrackingInfo({
    required this.busId,
    this.routeName = '',
    this.driverName = '',
    this.status = 'Moving',
    this.latitude,
    this.longitude,
    this.stops = const [],
  });

  factory LiveTrackingInfo.fromJson(Map<String, dynamic> json) {
    return LiveTrackingInfo(
      busId: json['bus_id']?.toString() ?? '',
      routeName: json['route_name'] as String? ?? '',
      driverName: json['driver_name'] as String? ?? '',
      status: json['status'] as String? ?? 'Moving',
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      stops: (json['stops'] as List<dynamic>?)
              ?.map((e) => BusStop.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class BusStop {
  final String name;
  final String eta;
  final String status; // next, upcoming, completed

  BusStop({
    required this.name,
    this.eta = '',
    this.status = 'upcoming',
  });

  bool get isNext => status == 'next';

  factory BusStop.fromJson(Map<String, dynamic> json) {
    return BusStop(
      name: json['name'] as String? ?? '',
      eta: json['eta'] as String? ?? '',
      status: json['status'] as String? ?? 'upcoming',
    );
  }
}

class StudentPickupStatus {
  final String studentId;
  final String studentName;
  final bool isPickedUp;

  StudentPickupStatus({
    required this.studentId,
    required this.studentName,
    this.isPickedUp = false,
  });

  String get statusLabel => isPickedUp ? 'Picked up' : 'Pending';

  factory StudentPickupStatus.fromJson(Map<String, dynamic> json) {
    return StudentPickupStatus(
      studentId: json['student_id']?.toString() ?? '',
      studentName: json['student_name'] as String? ?? '',
      isPickedUp: json['is_picked_up'] as bool? ?? false,
    );
  }
}
