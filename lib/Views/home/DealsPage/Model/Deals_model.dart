class DealsItem {
  final String category; // e.g., Service, Technology, Insurance
  final String title;
  final String description;
  final String promoCode;
  final String expiryDate; // e.g., Feb 15

  DealsItem({
    required this.category,
    required this.title,
    required this.description,
    required this.promoCode,
    required this.expiryDate,
  });
}
