class ServiceAreaModel {
  final String id;
  final String areaName;
  final String city;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  bool isExpanded;

  ServiceAreaModel({
    required this.id,
    required this.areaName,
    required this.city,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.isExpanded = false,
  });

  factory ServiceAreaModel.fromJson(Map<String, dynamic> json) {
    return ServiceAreaModel(
      id: json['_id']?.toString() ?? '',
      areaName: json['areaName']?.toString() ?? '',
      city: json['city']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
      isExpanded: false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'areaName': areaName,
      'city': city,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
