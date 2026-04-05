class MyJobsModel {
  bool? success;
  String? message;
  Pagination? pagination;
  List<JobData>? data;

  MyJobsModel({this.success, this.message, this.pagination, this.data});

  MyJobsModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    pagination =
        json['pagination'] != null ? Pagination.fromJson(json['pagination']) : null;

    if (json['data'] != null) {
      data = <JobData>[];
      json['data'].forEach((v) {
        data!.add(JobData.fromJson(v));
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

class JobData {
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
  String? instruction;
  String? status;
  String? rideStatus;
  dynamic createdBy;
  String? createdAt;
  String? updatedAt;

  Review? reviewByDriver;
  Review? reviewByCreator;
  Driver? assignedTo;
  Applicant? applicant;

  JobData({
    this.id,
    this.jobType,
    this.pickupLocation,
    this.dropoffLocation,
    this.flightNumber,
    this.asap,
    this.date,
    this.time,
    this.vehicleType,
    this.paymentAmount,
    this.paymentType,
    this.instruction,
    this.status,
    this.rideStatus,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
    this.reviewByDriver,
    this.reviewByCreator,
    this.assignedTo,
    this.applicant,
  });

  JobData.fromJson(Map<String, dynamic> json) {
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
    instruction = json['instruction'];
    status = json['status'];
    rideStatus = json['rideStatus'];
    
    // Handle createdBy as either String or Driver Object
    if (json['createdBy'] is Map<String, dynamic>) {
      createdBy = Driver.fromJson(json['createdBy']);
    } else {
      createdBy = json['createdBy']?.toString();
    }

    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];

    reviewByDriver = json['reviewByDriver'] != null
        ? Review.fromJson(json['reviewByDriver'])
        : null;

    reviewByCreator = json['reviewByCreator'] != null
        ? Review.fromJson(json['reviewByCreator'])
        : null;

    assignedTo = json['assignedTo'] != null
        ? Driver.fromJson(json['assignedTo'])
        : null;

    applicant = json['applicant'] != null
        ? Applicant.fromJson(json['applicant'])
        : null;
  }
}

class Review {
  int? rating;
  String? comment;
  String? reviewedAt;

  Review({this.rating, this.comment, this.reviewedAt});

  Review.fromJson(Map<String, dynamic> json) {
    rating = json['rating'];
    comment = json['comment'];
    reviewedAt = json['reviewedAt'];
  }
}

class Applicant {
  Driver? driver;
  String? appliedAt;

  Applicant({this.driver, this.appliedAt});

  Applicant.fromJson(Map<String, dynamic> json) {
    driver =
        json['driver'] != null ? Driver.fromJson(json['driver']) : null;
    appliedAt = json['appliedAt'];
  }
}

class Driver {
  String? id;
  String? name;
  String? email;
  String? phone;
  String? company;
  String? companyRole;
  String? profilePicture;
  String? nickname;
  List<Vehicle>? vehicles;
  double? averageRating;
  int? totalReviews;

  Driver({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.company,
    this.companyRole,
    this.profilePicture,
    this.nickname,
    this.vehicles,
    this.averageRating,
    this.totalReviews,
  });

  Driver.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    company = json['company'];
    companyRole = json['companyRole'];
    profilePicture = json['profilePicture'];
    nickname = json['nickname'];
    averageRating = (json['averageRating'] as num?)?.toDouble();
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