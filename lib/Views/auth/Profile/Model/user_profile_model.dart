class UserProfileModel {
  final String id;
  final String name;
  final String role;
  final String email;
  final String phone;
  final String home;
  final String serviceArea;
  final int experience;
  final String company;
  final String companyRole;
  final String profilePicture;
  final String status;
  final bool verified;
  final List<String> deviceTokens;
  final List<Vehicle> vehicles;
  final DateTime createdAt;
  final DateTime updatedAt;
  final double averageRating;
  final String? selectedVehicle;
  final String? nickname;
  final String? uid;

  UserProfileModel({
    required this.id,
    required this.name,
    required this.role,
    required this.email,
    required this.phone,
    required this.home,
    required this.serviceArea,
    required this.experience,
    required this.company,
    required this.companyRole,
    required this.profilePicture,
    required this.status,
    required this.verified,
    required this.deviceTokens,
    required this.vehicles,
    required this.createdAt,
    required this.updatedAt,
    this.averageRating = 0.0,
    this.selectedVehicle,
    this.nickname,
    this.uid,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json['_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      role: json['role']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      home: json['home']?.toString() ?? '',
      serviceArea: json['serviceArea']?.toString() ?? '',
      experience: json['experience'] is int ? json['experience'] : 0,
      company: json['company']?.toString() ?? '',
      companyRole: json['companyRole']?.toString() ?? '',
      profilePicture: json['profilePicture']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      verified: json['verified'] ?? false,
      deviceTokens:
          (json['deviceTokens'] as List?)?.map((e) => e.toString()).toList() ??
          [],
      vehicles:
          (json['vehicles'] as List?)
              ?.map((e) => Vehicle.fromJson(e))
              .toList() ??
          [],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
      averageRating: (json['averageRating'] ?? 0.0).toDouble(),
      selectedVehicle: json['selectedVehicle']?.toString(),
      nickname: json['nickname']?.toString(),
      uid: json['uid']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'role': role,
      'email': email,
      'phone': phone,
      'home': home,
      'serviceArea': serviceArea,
      'experience': experience,
      'company': company,
      'companyRole': companyRole,
      'profilePicture': profilePicture,
      'status': status,
      'verified': verified,
      'deviceTokens': deviceTokens,
      'vehicles': vehicles.map((e) => e.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'averageRating': averageRating,
      'selectedVehicle': selectedVehicle,
      'nickname': nickname,
      'uid': uid,
    };
  }
}

class Vehicle {
  final String id;
  final String carType;
  final String make;
  final String model;
  final String colorInside;
  final String colorOutside;
  final int year;
  final String licensePlate;
  final String? vehicleRegistrationImage;
  final String? vehicleRegistrationExpiryDate;
  final String? commercialInsuranceImage;
  final String? commercialInsuranceExpiryDate;
  final String? vehiclePhotoFront;
  final String? vehiclePhotoRear;
  final String? vehiclePhotoInterior;

  Vehicle({
    required this.id,
    required this.carType,
    required this.make,
    required this.model,
    required this.colorInside,
    required this.colorOutside,
    required this.year,
    required this.licensePlate,
    this.vehicleRegistrationImage,
    this.vehicleRegistrationExpiryDate,
    this.commercialInsuranceImage,
    this.commercialInsuranceExpiryDate,
    this.vehiclePhotoFront,
    this.vehiclePhotoRear,
    this.vehiclePhotoInterior,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      id: json['_id']?.toString() ?? '',
      carType: json['carType']?.toString() ?? '',
      make: json['make']?.toString() ?? '',
      model: json['model']?.toString() ?? '',
      colorInside: json['colorInside']?.toString() ?? '',
      colorOutside: json['colorOutside']?.toString() ?? '',
      year: json['year'] is int ? json['year'] : 0,
      licensePlate: json['licensePlate']?.toString() ?? '',
      vehicleRegistrationImage: json['vehicleRegistrationImage']?.toString(),
      vehicleRegistrationExpiryDate: json['vehicleRegistrationExpiryDate']
          ?.toString(),
      commercialInsuranceImage: json['commercialInsuranceImage']?.toString(),
      commercialInsuranceExpiryDate: json['commercialInsuranceExpiryDate']
          ?.toString(),
      vehiclePhotoFront: json['vehiclePhotoFront']?.toString(),
      vehiclePhotoRear: json['vehiclePhotoRear']?.toString(),
      vehiclePhotoInterior: json['vehiclePhotoInterior']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'carType': carType,
      'make': make,
      'model': model,
      'colorInside': colorInside,
      'colorOutside': colorOutside,
      'year': year,
      'licensePlate': licensePlate,
      'vehicleRegistrationImage': vehicleRegistrationImage,
      'vehicleRegistrationExpiryDate': vehicleRegistrationExpiryDate,
      'commercialInsuranceImage': commercialInsuranceImage,
      'commercialInsuranceExpiryDate': commercialInsuranceExpiryDate,
      'vehiclePhotoFront': vehiclePhotoFront,
      'vehiclePhotoRear': vehiclePhotoRear,
      'vehiclePhotoInterior': vehiclePhotoInterior,
    };
  }
}
