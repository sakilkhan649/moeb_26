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
    return ExpenseModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      category: json['category'] ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      date: json['date'] != null ? DateTime.parse(json['date']) : DateTime.now(),
      description: json['description'] ?? '',
      receiptImageUrl: json['receiptImageUrl'],
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
