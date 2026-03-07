class MyItemsModel {
  final String id;
  final String name;
  final String price;
  final double rating;
  final String imagePath;
  final String condition;
  final String status;
  final String location;
  final String description;
  final List<String> photos;
  final DateTime createdAt;

  MyItemsModel({
    required this.id,
    required this.name,
    required this.price,
    required this.rating,
    required this.imagePath,
    required this.condition,
    required this.status,
    required this.location,
    required this.description,
    required this.photos,
    required this.createdAt,
  });

  factory MyItemsModel.fromJson(Map<String, dynamic> json) {
    List<String> photosList =
        (json['photos'] as List?)?.map((e) => e.toString()).toList() ?? [];
    String firstPhoto = photosList.isNotEmpty ? photosList[0] : '';

    return MyItemsModel(
      id: json['_id']?.toString() ?? '',
      name: json['title']?.toString() ?? '',
      price: json['price']?.toString() ?? '0',
      rating: 5.0,
      imagePath: firstPhoto,
      condition: json['condition']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      location: json['location']?.toString() ?? '',
      description: json['description'] ?? '',
      photos: photosList,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': name,
      'price': price,
      'condition': condition,
      'status': status,
      'location': location,
      'description': description,
      'photos': photos,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
