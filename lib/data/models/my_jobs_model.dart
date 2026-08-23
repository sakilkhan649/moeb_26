class MyJobsModel {
  bool? success;
  String? message;
  CursorPagination? cursor;
  List<JobData>? data;

  MyJobsModel({this.success, this.message, this.cursor, this.data});

  MyJobsModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    cursor = json['cursor'] != null
        ? CursorPagination.fromJson(json['cursor'])
        : null;

    if (json['data'] != null) {
      data = <JobData>[];
      json['data'].forEach((v) {
        data!.add(JobData.fromJson(v));
      });
    }
  }
}

class CursorPagination {
  String? nextCursor;
  bool? hasMore;
  int? limit;

  CursorPagination({this.nextCursor, this.hasMore, this.limit});

  CursorPagination.fromJson(Map<String, dynamic> json) {
    nextCursor = json['nextCursor']?.toString();
    hasMore = json['hasMore'] is bool ? json['hasMore'] : null;
    limit = json['limit'] != null
        ? (num.tryParse(json['limit'].toString())?.toInt())
        : null;
  }
}

class JobData {
  String? id;
  String? jobType;
  String? pickupLocation;
  String? dropoffLocation;
  String? companyName;
  String? flightNumber;
  bool? asap;
  String? date;
  String? time;
  String? vehicleType;
  int? paymentAmount;
  String? paymentType;
  String? instruction;
  String? serviceArea;
  String? dispatchType;
  String? status;
  String? rideStatus;
  int? applicantCount;
  dynamic createdBy;
  String? createdAt;
  String? updatedAt;
  bool? hasReview;
  bool? isReviewedByCreator;
  bool? isReviewedByDriver;

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
    this.serviceArea,
    this.dispatchType,
    this.status,
    this.rideStatus,
    this.applicantCount,
    this.createdBy,
    this.companyName,
    this.createdAt,
    this.updatedAt,
    this.reviewByDriver,
    this.reviewByCreator,
    this.assignedTo,
    this.applicant,
    this.hasReview,
    this.isReviewedByCreator,
    this.isReviewedByDriver,
  });

  JobData.fromJson(Map<String, dynamic> json) {
    companyName = json['companyName'];
    id = json['_id'] ?? json['id'];
    jobType = json['jobType'];
    pickupLocation = json['pickup'] ?? json['pickupLocation'];
    dropoffLocation = json['dropoff'] ?? json['dropoffLocation'];
    flightNumber = json['flightNumber'];
    asap = json['asap'];
    date = json['date'];
    time = json['time'];
    vehicleType = json['vehicleType'];
    paymentAmount = json['paymentAmount'] != null
        ? (num.tryParse(json['paymentAmount'].toString())?.toInt() ?? 0)
        : null;
    paymentType = json['paymentType'];
    instruction = json['instruction'];
    serviceArea = json['serviceArea'];
    dispatchType = json['dispatchType'];
    status = json['status'];
    rideStatus = json['rideStatus'];
    applicantCount = json['applicantCount'] != null
        ? (num.tryParse(json['applicantCount'].toString())?.toInt() ?? 0)
        : 0;
    hasReview = json['hasReview'];
    isReviewedByCreator = json['isReviewedByCreator'];
    isReviewedByDriver = json['isReviewedByDriver'];

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
    if (json['driver'] != null) {
      driver = Driver.fromJson(json['driver']);
    } else if (json['name'] != null || json['_id'] != null) {
      driver = Driver.fromJson(json);
    }
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
