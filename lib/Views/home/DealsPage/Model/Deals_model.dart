class DealsResponse {
  bool? success;
  String? message;
  Pagination? pagination;
  List<DealsItem>? data;

  DealsResponse({this.success, this.message, this.pagination, this.data});

  DealsResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];

    pagination = json['pagination'] != null
        ? Pagination.fromJson(json['pagination'])
        : null;

    if (json['data'] != null) {
      data = <DealsItem>[];
      json['data'].forEach((v) {
        data!.add(DealsItem.fromJson(v));
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

class DealsItem {
  final String id;
  final String title;
  final String description;
  final List<String> tags;
  final String promoCode;
  final String qrCode;
  final DateTime expiryDate;

  DealsItem({
    required this.id,
    required this.title,
    required this.description,
    required this.tags,
    required this.promoCode,
    required this.qrCode,
    required this.expiryDate,
  });

  factory DealsItem.fromJson(Map<String, dynamic> json) {
    return DealsItem(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      tags: List<String>.from(json['tags'] ?? []),
      promoCode: json['promoCode'] ?? '',
      qrCode: json['qrCode'] ?? '',
      expiryDate: DateTime.parse(
        json['expireDate'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }
}
