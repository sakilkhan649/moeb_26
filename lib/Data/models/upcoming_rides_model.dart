class UpcomingRidesModel {
  bool? success;
  String? message;
  Pagination? pagination;
  List<UpcomingRideData>? data;

  UpcomingRidesModel({this.success, this.message, this.pagination, this.data});

  UpcomingRidesModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];

    pagination = json['pagination'] != null
        ? Pagination.fromJson(json['pagination'])
        : null;

    if (json['data'] != null) {
      data = <UpcomingRideData>[];
      json['data'].forEach((v) {
        data!.add(UpcomingRideData.fromJson(v));
      });
    }
  }
}

class Pagination {
  int? total;
  int? limit;
  int? page;
  int? totalPage;

  Pagination({this.total, this.limit, this.page, this.totalPage});

  Pagination.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    limit = json['limit'];
    page = json['page'];
    totalPage = json['totalPage'];
  }
}

class UpcomingRideData {
  String? id;
  String? jobType;
  String? pickupLocation;
  String? dropoffLocation;
  String? flightNumber;
  bool? asap;
  String? date;
  String? time;
  String? vehicleType;
  int? paymentAmount;
  String? paymentType;
  String? status;
  String? rideStatus;
  String? createdAt;
  String? updatedAt;
  String? assignedTo;
  Driver? createdBy;

  UpcomingRideData({
    this.id,
    this.jobType,
    this.pickupLocation,
    this.dropoffLocation,
    this.flightNumber,
    this.date,
    this.time,
    this.vehicleType,
    this.paymentAmount,
    this.paymentType,
    this.status,
    this.rideStatus,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
    this.assignedTo,
  });

  UpcomingRideData.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    jobType = json['jobType'];
    pickupLocation = json['pickupLocation'];
    dropoffLocation = json['dropoffLocation'];
    flightNumber = json['flightNumber'];
    asap = json['asap'];
    date = json['date'];
    time = json['time'];
    vehicleType = json['vehicleType'];
    paymentAmount = json['paymentAmount'];
    paymentType = json['paymentType'];
    status = json['status'];
    rideStatus = json['rideStatus'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    assignedTo = json['assignedTo'];

    createdBy = json['createdBy'] != null
        ? Driver.fromJson(json['createdBy'])
        : null;
  }
}

class Driver {
  String? id;
  String? name;
  String? email;
  String? phone;
  String? profilePicture;
  String? company;
  String? nickname;
  double? averageRating;
  int? totalReviews;
  List<Vehicle>? vehicles;

  Driver({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.profilePicture,
    this.company,
    this.nickname,
    this.averageRating,
    this.totalReviews,
    this.vehicles,
  });

  Driver.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    profilePicture = json['profilePicture'];
    company = json['company'];
    nickname = json['nickname'];
    averageRating = (json['averageRating'] ?? 0).toDouble();
    totalReviews = json['totalReviews'];

    if (json['vehicles'] != null) {
      vehicles = <Vehicle>[];
      json['vehicles'].forEach((v) {
        vehicles!.add(Vehicle.fromJson(v));
      });
    }
  }
}

class Vehicle {
  String? id;
  String? carType;
  String? make;
  String? model;
  String? colorInside;
  String? colorOutside;
  int? year;
  String? licensePlate;

  Vehicle({
    this.id,
    this.carType,
    this.make,
    this.model,
    this.colorInside,
    this.colorOutside,
    this.year,
    this.licensePlate,
  });

  Vehicle.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    carType = json['carType'];
    make = json['make'];
    model = json['model'];
    colorInside = json['colorInside'];
    colorOutside = json['colorOutside'];
    year = json['year'];
    licensePlate = json['licensePlate'];
  }
}