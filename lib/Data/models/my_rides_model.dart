class MyRidesResponse {
  final bool success;
  final String message;
  final Pagination? pagination;
  final List<Ride> data;

  MyRidesResponse({
    required this.success,
    required this.message,
    this.pagination,
    required this.data,
  });

  factory MyRidesResponse.fromJson(Map<String, dynamic> json) {
    return MyRidesResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      pagination: json['pagination'] != null
          ? Pagination.fromJson(json['pagination'])
          : null,
      data: json['data'] != null
          ? (json['data'] as List)
                .map((x) {
                  try {
                    return Ride.fromJson(x);
                  } catch (e, stacktrace) {
                    print("Error parsing ride: $e");
                    print(stacktrace);
                    return null;
                  }
                })
                .where((ride) => ride != null)
                .cast<Ride>()
                .toList()
          : [],
    );
  }
}

class Pagination {
  final int total;
  final int limit;
  final int page;
  final int totalPage;

  Pagination({
    required this.total,
    required this.limit,
    required this.page,
    required this.totalPage,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      total: json['total'] ?? 0,
      limit: json['limit'] ?? 0,
      page: json['page'] ?? 0,
      totalPage: json['totalPage'] ?? 0,
    );
  }
}

class Ride {
  final String id;
  final String pickupLocation;
  final String dropoffLocation;
  final String? flightNumber;
  final String vehicleType;
  final bool? asap;
  final num paymentAmount;
  final String paymentType;
  final String status;
  final DateTime? date;
  final String time;
  final String? rideStatus;
  final Applicant? applicant;
  final Driver? assignedTo;
  final Driver? createdBy;

  Ride({
    required this.id,
    required this.pickupLocation,
    required this.dropoffLocation,
    required this.vehicleType,
    this.asap,
    required this.paymentAmount,
    required this.paymentType,
    required this.status,
    this.date,
    required this.time,
    this.rideStatus,
    this.applicant,
    this.assignedTo,
    this.createdBy,
    this.flightNumber,
  });

  factory Ride.fromJson(Map<String, dynamic> json) {
    return Ride(
      id: json['_id'] ?? '',
      pickupLocation: json['pickupLocation'] ?? '',
      dropoffLocation: json['dropoffLocation'] ?? '',
      vehicleType: json['vehicleType'] ?? '',
      asap: json['asap'],
      paymentAmount: json['paymentAmount'] != null
          ? num.tryParse(json['paymentAmount'].toString()) ?? 0
          : 0,
      paymentType: json['paymentType'] ?? '',
      status: json['status'] ?? '',
      rideStatus: json['rideStatus'],
      date: json['date'] != null
          ? DateTime.tryParse(json['date'].toString())
          : null,
      time: json['time'] ?? '',
      applicant: (json['applicant'] != null && json['applicant'] is Map)
          ? Applicant.fromJson(json['applicant'])
          : null,
      assignedTo: (json['assignedTo'] != null && json['assignedTo'] is Map)
          ? Driver.fromJson(json['assignedTo'])
          : null,
      createdBy: (json['createdBy'] != null && json['createdBy'] is Map)
          ? Driver.fromJson(json['createdBy'])
          : null,
      flightNumber: json['flightNumber'],
    );
  }
}

class Driver {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String profilePicture;
  final String? company;
  final String? nickname;

  Driver({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.profilePicture,
    this.company,
    this.nickname,
  });

  factory Driver.fromJson(Map<String, dynamic> json) {
    return Driver(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      profilePicture: json['profilePicture'] ?? '',
      company: json['company'],
      nickname: json['nickname'],
    );
  }
}

class Applicant {
  final Driver? driver;
  final DateTime? appliedAt;

  Applicant({this.driver, this.appliedAt});

  factory Applicant.fromJson(Map<String, dynamic> json) {
    return Applicant(
      driver: (json['driver'] != null && json['driver'] is Map)
          ? Driver.fromJson(json['driver'])
          : null,
      appliedAt: json['appliedAt'] != null
          ? DateTime.tryParse(json['appliedAt'].toString())
          : null,
    );
  }
}
