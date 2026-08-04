import 'package:moeb_26/config/constants/api_constants.dart';

class ExpenseModel {
  final String id;
  final String userId;
  final String category;
  final double amount;
  final DateTime date;
  final String description;
  final String? receiptImageUrl;

  ExpenseModel({
    required this.id,
    required this.userId,
    required this.category,
    required this.amount,
    required this.date,
    required this.description,
    this.receiptImageUrl,
  });

  factory ExpenseModel.fromJson(Map<String, dynamic> json) {
    String rawReceipt = json['receipt'] ?? json['receiptImageUrl'] ?? '';
    String? parsedReceiptUrl;
    if (rawReceipt.isNotEmpty) {
      if (rawReceipt.startsWith('http://') || rawReceipt.startsWith('https://')) {
        parsedReceiptUrl = rawReceipt;
      } else if (rawReceipt.startsWith('//')) {
        parsedReceiptUrl = 'https:$rawReceipt';
      } else if (rawReceipt.startsWith('/')) {
        final serverBase = ApiConstants.baseUrl.replaceAll('/api/v1', '');
        parsedReceiptUrl = '$serverBase$rawReceipt';
      } else {
        parsedReceiptUrl = rawReceipt;
      }
    }

    return ExpenseModel(
      id: json['id'] ?? json['_id'] ?? '',
      userId: json['user'] ?? json['userId'] ?? '',
      category: json['category'] ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      date: json['date'] != null ? DateTime.parse(json['date']) : DateTime.now(),
      description: json['description'] ?? '',
      receiptImageUrl: parsedReceiptUrl,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'category': category,
      'amount': amount,
      'date': date.toIso8601String(),
      'description': description,
      'receiptImageUrl': receiptImageUrl,
    };
  }
}
