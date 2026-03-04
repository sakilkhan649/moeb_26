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
        json['expiryDate'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }
}
