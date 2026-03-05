class MyJobsModel {
  bool? success;
  String? message;
  Pagination? pagination;
  List<JobData>? data;

  MyJobsModel({this.success, this.message, this.pagination, this.data});

  MyJobsModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    pagination = json['pagination'] != null
        ? Pagination.fromJson(json['pagination'])
        : null;

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
  String? date;
  String? time;
  String? vehicleType;
  int? paymentAmount;
  String? paymentType;
  String? instruction;
  String? status;
  String? createdBy;
  String? createdAt;
  String? updatedAt;
  Applicant? applicant;

  JobData({
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
    this.instruction,
    this.status,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
    this.applicant,
  });

  JobData.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    jobType = json['jobType'];
    pickupLocation = json['pickupLocation'];
    dropoffLocation = json['dropoffLocation'];
    flightNumber = json['flightNumber'];
    date = json['date'];
    time = json['time'];
    vehicleType = json['vehicleType'];
    paymentAmount = json['paymentAmount'];
    paymentType = json['paymentType'];
    instruction = json['instruction'];
    status = json['status'];
    createdBy = json['createdBy'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];

    applicant =
        json['applicant'] != null ? Applicant.fromJson(json['applicant']) : null;
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
  String? profilePicture;

  Driver({this.id, this.name, this.email, this.phone, this.profilePicture});

  Driver.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    profilePicture = json['profilePicture'];
  }
}