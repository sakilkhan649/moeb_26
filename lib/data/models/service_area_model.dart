class ServiceAreaResponseModel {
  final bool success;
  final String message;
  final PaginationModel pagination;
  final List<ServiceAreaModel> data;

  ServiceAreaResponseModel({
    required this.success,
    required this.message,
    required this.pagination,
    required this.data,
  });

  factory ServiceAreaResponseModel.fromJson(Map<String, dynamic> json) {
    // Check if the data is wrapped in 'data' or 'service_areas' or similar
    var dataList =
        json['data'] ?? json['service_areas'] ?? json['results'] ?? [];

    // Check for pagination in various locations
    var paginationData = json['pagination'] ?? json['meta'] ?? json;

    return ServiceAreaResponseModel(
      success: json['success'] ?? true,
      message: json['message'] ?? '',
      pagination: PaginationModel.fromJson(
        Map<String, dynamic>.from(paginationData),
      ),
      data: (dataList as List)
          .map((e) => ServiceAreaModel.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
    );
  }
}

class PaginationModel {
  final int total;
  final int limit;
  final int page;
  final int totalPage;

  PaginationModel({
    required this.total,
    required this.limit,
    required this.page,
    required this.totalPage,
  });

  factory PaginationModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return PaginationModel(total: 0, limit: 0, page: 0, totalPage: 0);
    }
    return PaginationModel(
      total: json['total'] ?? json['total_items'] ?? 0,
      limit: json['limit'] ?? 0,
      page: json['page'] ?? json['current_page'] ?? 0,
      totalPage:
          json['totalPage'] ?? json['total_pages'] ?? json['total_page'] ?? 0,
    );
  }
}

class ServiceAreaModel {
  final String id;
  final String areaName;
  final String city;
  final List<String> cities;
  final String status;
  final int chauffeurCount;
  final DateTime createdAt;
  final DateTime updatedAt;
  bool isExpanded;

  ServiceAreaModel({
    required this.id,
    required this.areaName,
    required this.city,
    this.cities = const [],
    required this.status,
    this.chauffeurCount = 0,
    required this.createdAt,
    required this.updatedAt,
    this.isExpanded = false,
  });

  factory ServiceAreaModel.fromJson(Map<String, dynamic> json) {
    List<String> parsedCities = [];
    if (json['cities'] is List) {
      parsedCities = (json['cities'] as List)
          .map((e) => e?.toString() ?? '')
          .where((s) => s.isNotEmpty)
          .toList();
    } else if (json['city'] != null && json['city'].toString().isNotEmpty) {
      parsedCities = [json['city'].toString()];
    }

    final int count = json['chauffeurCount'] is int
        ? json['chauffeurCount']
        : int.tryParse(json['chauffeurCount']?.toString() ?? '0') ?? 0;

    DateTime parseDate(dynamic value) {
      if (value == null) return DateTime.now();
      return DateTime.tryParse(value.toString()) ?? DateTime.now();
    }

    return ServiceAreaModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      areaName: json['areaName']?.toString() ?? json['name']?.toString() ?? '',
      city: json['city']?.toString() ??
          (parsedCities.isNotEmpty ? parsedCities.first : ''),
      cities: parsedCities,
      status: json['status']?.toString() ?? 'ACTIVE',
      chauffeurCount: count,
      createdAt: parseDate(json['createdAt'] ?? json['created_at']),
      updatedAt: parseDate(json['updatedAt'] ?? json['updated_at']),
      isExpanded: false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'areaName': areaName,
      'city': city,
      'cities': cities,
      'status': status,
      'chauffeurCount': chauffeurCount,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
