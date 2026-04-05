class JobResponse {
  final bool success;
  final String message;
  final Pagination? pagination;
  final List<Job> data;

  JobResponse({
    required this.success,
    required this.message,
    this.pagination,
    required this.data,
  });

  factory JobResponse.fromJson(Map<String, dynamic> json) {
    return JobResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      pagination: json['pagination'] != null
          ? Pagination.fromJson(json['pagination'])
          : null,
      data: json['data'] != null
          ? (json['data'] as List)
                .map((x) {
                  try {
                    return Job.fromJson(x);
                  } catch (e, stacktrace) {
                    print("Error parsing an individual job: $e");
                    print(stacktrace);
                    return null;
                  }
                })
                .where((job) => job != null)
                .cast<Job>()
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

class Job {
  final String id;
  final String jobType;
  final String pickupLocation;
  final String? dropoffLocation;
  final String? flightNumber;
  final bool? asap;
  final DateTime? date;
  final String time;
  final String vehicleType;
  final num paymentAmount;
  final String paymentType;
  final String? instruction;
  final String status;
  final CreatedBy? createdBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Job({
    required this.id,
    required this.jobType,
    required this.pickupLocation,
    this.dropoffLocation,
    this.flightNumber,
    this.asap,
    this.date,
    required this.time,
    required this.vehicleType,
    required this.paymentAmount,
    required this.paymentType,
    this.instruction,
    required this.status,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
  });

  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      id: json['_id'] ?? '',
      jobType: json['jobType'] ?? '',
      pickupLocation: json['pickupLocation'] ?? '',
      dropoffLocation: json['dropoffLocation'],
      flightNumber: json['flightNumber'],
      asap: json['asap'],
      date: json['date'] != null
          ? DateTime.tryParse(json['date'].toString())
          : null,
      time: json['time'] ?? '',
      vehicleType: json['vehicleType'] ?? '',
      paymentAmount: json['paymentAmount'] != null
          ? num.tryParse(json['paymentAmount'].toString()) ?? 0
          : 0,
      paymentType: json['paymentType'] ?? '',
      instruction: json['instruction'],
      status: json['status'] ?? '',
      createdBy:
          (json['createdBy'] != null &&
              json['createdBy'] is Map<String, dynamic>)
          ? CreatedBy.fromJson(json['createdBy'])
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'].toString())
          : null,
    );
  }
}

class CreatedBy {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String profilePicture;
  final String nickname;
  final String companyName;

  CreatedBy({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.profilePicture, required this.nickname, required this.companyName,
  });

  factory CreatedBy.fromJson(Map<String, dynamic> json) {
    return CreatedBy(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      profilePicture: json['profilePicture'] ?? '',
      nickname: json['nickname'] ?? '',
      companyName: json['company'] ?? '',
    );
  }
}
