class MarketplaceItem {
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
  final CreatedBy createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;

  MarketplaceItem({
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
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MarketplaceItem.fromJson(Map<String, dynamic> json) {
    List<String> photosList = (json['photos'] as List?)?.map((e) => e.toString()).toList() ?? [];
    String firstPhoto = photosList.isNotEmpty ? photosList[0] : '';
    
    return MarketplaceItem(
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
      createdBy: CreatedBy.fromJson(json['createdBy'] ?? {}),
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : DateTime.now(),
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
      'createdBy': createdBy.toJson(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

class CreatedBy {
  final String id;
  final String name;
  final String email;
  final String profilePicture;

  CreatedBy({
    required this.id,
    required this.name,
    required this.email,
    required this.profilePicture,
  });

  factory CreatedBy.fromJson(Map<String, dynamic> json) {
    return CreatedBy(
      id: json['_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      profilePicture: json['profilePicture']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'profilePicture': profilePicture,
    };
  }
}
