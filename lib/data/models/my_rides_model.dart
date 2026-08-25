import 'package:moeb_26/data/models/user_profile_model.dart';

class MyRidesModel {
  final bool success;
  final String message;
  final CursorPagination? cursor;
  final List<RideData> data;

  MyRidesModel({
    required this.success,
    required this.message,
    this.cursor,
    required this.data,
  });

  factory MyRidesModel.fromJson(Map<String, dynamic> json) {
    return MyRidesModel(
      success: json['success'] ?? false,
      message: json['message']?.toString() ?? '',
      cursor: json['cursor'] != null && json['cursor'] is Map<String, dynamic>
          ? CursorPagination.fromJson(json['cursor'])
          : null,
      data: json['data'] != null && json['data'] is List
          ? (json['data'] as List)
              .map((x) {
                try {
                  if (x is Map<String, dynamic>) {
                    return RideData.fromJson(x);
                  }
                  return null;
                } catch (e, stacktrace) {
                  print("Error parsing ride: $e");
                  print(stacktrace);
                  return null;
                }
              })
              .where((ride) => ride != null)
              .cast<RideData>()
              .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'cursor': cursor?.toJson(),
      'data': data.map((v) => v.toJson()).toList(),
    };
  }
}

class CursorPagination {
  final String? nextCursor;
  final bool hasMore;
  final int limit;

  CursorPagination({
    this.nextCursor,
    this.hasMore = false,
    this.limit = 10,
  });

  factory CursorPagination.fromJson(Map<String, dynamic> json) {
    return CursorPagination(
      nextCursor: json['nextCursor']?.toString(),
      hasMore: json['hasMore'] is bool ? json['hasMore'] : false,
      limit: json['limit'] != null
          ? (int.tryParse(json['limit'].toString()) ?? 10)
          : 10,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nextCursor': nextCursor,
      'hasMore': hasMore,
      'limit': limit,
    };
  }
}

class RideData {
  final String id;
  final String? jobType;
  final String pickupLocation;
  final String dropoffLocation;
  final String? flightNumber;
  final bool asap;
  final String? date;
  final String? time;
  final String vehicleType;
  final num? paymentAmount;
  final String? paymentType;
  final String? instruction;
  final String? serviceArea;
  final String? dispatchType;
  final bool isPersonalNote;
  final String? passengerName;
  final String? passengerPhone;
  final String? status;
  final String? rideStatus;
  final String? companyName;
  final String? name;
  final String? nickname;
  final String? company;
  final String? companyRole;
  final String? profilePicture;
  final DriverData? createdBy;
  final DriverData? assignedTo;
  final ApplicantData? applicant;
  final List<String> targetedChauffeurs;
  final String? createdAt;
  final String? updatedAt;

  RideData({
    required this.id,
    this.jobType,
    required this.pickupLocation,
    required this.dropoffLocation,
    this.flightNumber,
    this.asap = false,
    this.date,
    this.time,
    required this.vehicleType,
    this.paymentAmount,
    this.paymentType,
    this.instruction,
    this.serviceArea,
    this.dispatchType,
    this.isPersonalNote = false,
    this.passengerName,
    this.passengerPhone,
    this.status,
    this.rideStatus,
    this.companyName,
    this.name,
    this.nickname,
    this.company,
    this.companyRole,
    this.profilePicture,
    this.createdBy,
    this.assignedTo,
    this.applicant,
    this.targetedChauffeurs = const [],
    this.createdAt,
    this.updatedAt,
  });

  factory RideData.fromJson(Map<String, dynamic> json) {
    DriverData? parseDriver(dynamic field) {
      if (field is Map<String, dynamic>) {
        return DriverData.fromJson(field);
      }
      return null;
    }

    final parsedCreatedBy = parseDriver(json['createdBy']) ??
        ((json['name'] != null || json['nickname'] != null || json['profilePicture'] != null)
            ? DriverData(
                id: json['creatorId']?.toString() ?? '',
                name: json['name']?.toString() ?? '',
                nickname: json['nickname']?.toString(),
                email: json['email']?.toString() ?? '',
                phone: json['phone']?.toString() ?? '',
                company: json['company']?.toString(),
                companyRole: json['companyRole']?.toString(),
                profilePicture: json['profilePicture']?.toString() ?? '',
              )
            : null);

    return RideData(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      jobType: json['jobType']?.toString(),
      pickupLocation: json['pickup']?.toString() ??
          json['pickupLocation']?.toString() ??
          '',
      dropoffLocation: json['dropoff']?.toString() ??
          json['dropoffLocation']?.toString() ??
          '',
      flightNumber: json['flightNumber']?.toString(),
      asap: json['asap'] is bool ? json['asap'] : false,
      date: json['date']?.toString(),
      time: json['time']?.toString(),
      vehicleType: json['vehicleType']?.toString() ?? 'N/A',
      paymentAmount: json['paymentAmount'] != null
          ? num.tryParse(json['paymentAmount'].toString())
          : null,
      paymentType: json['paymentType']?.toString(),
      instruction: json['instruction']?.toString() ??
          json['instructions']?.toString() ??
          json['specialInstructions']?.toString(),
      serviceArea: json['serviceArea']?.toString(),
      dispatchType: json['dispatchType']?.toString(),
      isPersonalNote: json['isPersonalNote'] is bool ? json['isPersonalNote'] : false,
      passengerName: json['passengerName']?.toString(),
      passengerPhone: json['passengerPhone']?.toString(),
      status: json['status']?.toString(),
      rideStatus: json['rideStatus']?.toString(),
      companyName: json['companyName']?.toString() ?? json['company']?.toString(),
      name: json['name']?.toString(),
      nickname: json['nickname']?.toString(),
      company: json['company']?.toString(),
      companyRole: json['companyRole']?.toString(),
      profilePicture: json['profilePicture']?.toString(),
      createdBy: parsedCreatedBy,
      assignedTo: parseDriver(json['assignedTo']),
      applicant: json['applicant'] != null && json['applicant'] is Map<String, dynamic>
          ? ApplicantData.fromJson(json['applicant'])
          : null,
      targetedChauffeurs: json['targetedChauffeurs'] != null && json['targetedChauffeurs'] is List
          ? List<String>.from(json['targetedChauffeurs'].map((e) => e.toString()))
          : const [],
      createdAt: json['createdAt']?.toString(),
      updatedAt: json['updatedAt']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'jobType': jobType,
      'pickup': pickupLocation,
      'dropoff': dropoffLocation,
      'flightNumber': flightNumber,
      'asap': asap,
      'date': date,
      'time': time,
      'vehicleType': vehicleType,
      'paymentAmount': paymentAmount,
      'paymentType': paymentType,
      'instruction': instruction,
      'serviceArea': serviceArea,
      'dispatchType': dispatchType,
      'isPersonalNote': isPersonalNote,
      'passengerName': passengerName,
      'passengerPhone': passengerPhone,
      'status': status,
      'rideStatus': rideStatus,
      'companyName': companyName,
      'createdBy': createdBy?.toJson(),
      'assignedTo': assignedTo?.toJson(),
      'applicant': applicant?.toJson(),
      'targetedChauffeurs': targetedChauffeurs,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}

class DriverData {
  final String id;
  final String name;
  final String? nickname;
  final String email;
  final String phone;
  final String? company;
  final String? companyRole;
  final String profilePicture;
  final String? selectedVehicle;
  final double? averageRating;
  final int? totalReviews;
  final List<Vehicle>? vehicles;

  DriverData({
    required this.id,
    required this.name,
    this.nickname,
    required this.email,
    required this.phone,
    this.company,
    this.companyRole,
    required this.profilePicture,
    this.selectedVehicle,
    this.averageRating,
    this.totalReviews,
    this.vehicles,
  });

  factory DriverData.fromJson(Map<String, dynamic> json) {
    List<Vehicle>? vehicleList;
    if (json['vehicles'] != null && json['vehicles'] is List) {
      vehicleList = (json['vehicles'] as List)
          .map((v) => Vehicle.fromJson(v as Map<String, dynamic>))
          .toList();
    }

    return DriverData(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      nickname: json['nickname']?.toString(),
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      company: json['company']?.toString(),
      companyRole: json['companyRole']?.toString(),
      profilePicture: json['profilePicture']?.toString() ?? '',
      selectedVehicle: json['selectedVehicle']?.toString(),
      averageRating: json['averageRating'] != null
          ? (num.tryParse(json['averageRating'].toString())?.toDouble())
          : null,
      totalReviews: json['totalReviews'] != null
          ? (num.tryParse(json['totalReviews'].toString())?.toInt())
          : null,
      vehicles: vehicleList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'nickname': nickname,
      'email': email,
      'phone': phone,
      'company': company,
      'companyRole': companyRole,
      'profilePicture': profilePicture,
      'selectedVehicle': selectedVehicle,
      'averageRating': averageRating,
      'totalReviews': totalReviews,
    };
  }
}

class ApplicantData {
  final DriverData? driver;
  final String? vehicleId;
  final DateTime? appliedAt;

  ApplicantData({
    this.driver,
    this.vehicleId,
    this.appliedAt,
  });

  factory ApplicantData.fromJson(Map<String, dynamic> json) {
    return ApplicantData(
      driver: json['driver'] != null && json['driver'] is Map<String, dynamic>
          ? DriverData.fromJson(json['driver'])
          : null,
      vehicleId: json['vehicleId']?.toString(),
      appliedAt: json['appliedAt'] != null
          ? DateTime.tryParse(json['appliedAt'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'driver': driver?.toJson(),
      'vehicleId': vehicleId,
      'appliedAt': appliedAt?.toIso8601String(),
    };
  }
}

// Aliases for clean compatibility across existing files
typedef Ride = RideData;
typedef Driver = DriverData;
typedef Applicant = ApplicantData;
typedef MyRidesResponse = MyRidesModel;
typedef UpcomingRideData = RideData;
typedef FinishRideData = RideData;
typedef UpcomingRidesModel = MyRidesModel;
typedef FinishRidesModel = MyRidesModel;


