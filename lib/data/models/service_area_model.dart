class ServiceAreaResponseModel {
  final bool success;
  final String message;
  final CursorModel? cursor;
  final List<ServiceAreaModel> data;

  ServiceAreaResponseModel({
    required this.success,
    required this.message,
    this.cursor,
    required this.data,
  });

  factory ServiceAreaResponseModel.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'] ?? json['service_areas'] ?? [];
    final List list = rawData is List ? rawData : [];

    return ServiceAreaResponseModel(
      success: json['success'] == true,
      message: json['message']?.toString() ?? '',
      cursor: json['cursor'] != null && json['cursor'] is Map
          ? CursorModel.fromJson(Map<String, dynamic>.from(json['cursor']))
          : null,
      data: list
          .map((e) => ServiceAreaModel.fromJson(
                e is Map
                    ? Map<String, dynamic>.from(e)
                    : {'areaName': e.toString()},
              ))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      if (cursor != null) 'cursor': cursor!.toJson(),
      'data': data.map((e) => e.toJson()).toList(),
    };
  }
}

class CursorModel {
  final String? nextCursor;
  final bool hasMore;
  final int limit;

  CursorModel({
    this.nextCursor,
    this.hasMore = false,
    this.limit = 10,
  });

  factory CursorModel.fromJson(Map<String, dynamic> json) {
    return CursorModel(
      nextCursor: json['nextCursor']?.toString(),
      hasMore: json['hasMore'] == true,
      limit: json['limit'] is int
          ? json['limit'] as int
          : (int.tryParse(json['limit']?.toString() ?? '10') ?? 10),
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

class ServiceAreaModel {
  final String id;
  final String areaName;
  final String city;
  final List<String> cities;
  final String status;
  bool isExpanded;

  ServiceAreaModel({
    required this.id,
    required this.areaName,
    this.city = '',
    this.cities = const [],
    this.status = 'ACTIVE',
    this.isExpanded = false,
  });

  factory ServiceAreaModel.fromJson(Map<String, dynamic> json) {
    final String areaName =
        json['areaName']?.toString() ?? json['name']?.toString() ?? '';

    List<String> parsedCities = [];
    if (json['cities'] is List) {
      parsedCities = (json['cities'] as List)
          .map((e) => e?.toString() ?? '')
          .where((s) => s.isNotEmpty)
          .toList();
    } else if (json['city'] != null && json['city'].toString().isNotEmpty) {
      parsedCities = [json['city'].toString()];
    }

    final String singleCity = json['city']?.toString() ??
        (parsedCities.isNotEmpty ? parsedCities.first : areaName);

    return ServiceAreaModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      areaName: areaName,
      city: singleCity,
      cities: parsedCities.isNotEmpty ? parsedCities : (areaName.isNotEmpty ? [areaName] : []),
      status: json['status']?.toString() ?? 'ACTIVE',
      isExpanded: false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'areaName': areaName,
      if (city.isNotEmpty) 'city': city,
      if (status.isNotEmpty) 'status': status,
    };
  }
}
