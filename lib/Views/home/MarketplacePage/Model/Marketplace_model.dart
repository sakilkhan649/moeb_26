// class MarketplaceItem {
//   final String id;
//   final String name;
//   final String price;
//   final double rating;
//   final String imagePath;
//   final String condition;
//   final String status;
//   final String location;
//   final String description;
//   final List<String> photos;
//   final CreatedBy createdBy;
//   final DateTime createdAt;
//   final DateTime updatedAt;

//   MarketplaceItem({
//     required this.id,
//     required this.name,
//     required this.price,
//     required this.rating,
//     required this.imagePath,
//     required this.condition,
//     required this.status,
//     required this.location,
//     required this.description,
//     required this.photos,
//     required this.createdBy,
//     required this.createdAt,
//     required this.updatedAt,
//   });

//   factory MarketplaceItem.fromJson(Map<String, dynamic> json) {
//     List<String> photosList = (json['photos'] as List?)?.map((e) => e.toString()).toList() ?? [];
//     String firstPhoto = photosList.isNotEmpty ? photosList[0] : '';
    
//     return MarketplaceItem(
//       id: json['_id']?.toString() ?? '',
//       name: json['title']?.toString() ?? '',
//       price: json['price']?.toString() ?? '0',
//       rating: 5.0, 
//       imagePath: firstPhoto,
//       condition: json['condition']?.toString() ?? '',
//       status: json['status']?.toString() ?? '',
//       location: json['location']?.toString() ?? '',
//       description: json['description'] ?? '',
//       photos: photosList,
//       createdBy: CreatedBy.fromJson(json['createdBy'] ?? {}),
//       createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
//       updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : DateTime.now(),
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       '_id': id,
//       'title': name,
//       'price': price,
//       'condition': condition,
//       'status': status,
//       'location': location,
//       'description': description,
//       'photos': photos,
//       'createdBy': createdBy.toJson(),
//       'createdAt': createdAt.toIso8601String(),
//       'updatedAt': updatedAt.toIso8601String(),
//     };
//   }
// }

// class CreatedBy {
//   final String id;
//   final String name;
//   final String email;
//   final String profilePicture;

//   CreatedBy({
//     required this.id,
//     required this.name,
//     required this.email,
//     required this.profilePicture,
//   });

//   factory CreatedBy.fromJson(Map<String, dynamic> json) {
//     return CreatedBy(
//       id: json['_id']?.toString() ?? '',
//       name: json['name']?.toString() ?? '',
//       email: json['email']?.toString() ?? '',
//       profilePicture: json['profilePicture']?.toString() ?? '',
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       '_id': id,
//       'name': name,
//       'email': email,
//       'profilePicture': profilePicture,
//     };
//   }
// }














class MarketplaceModel {
  bool? success;
  String? message;
  Pagination? pagination;
  List<ItemData>? data;
 
  MarketplaceModel({this.success, this.message, this.pagination, this.data});
 
  MarketplaceModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
 
    pagination = json['pagination'] != null
        ? Pagination.fromJson(json['pagination'])
        : null;
 
    if (json['data'] != null) {
      data = <ItemData>[];
      json['data'].forEach((v) {
        data!.add(ItemData.fromJson(v));
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
 
class ItemData {
  String? id;
  String? title;
  int? price;
  String? condition;
  String? status;
  String? location;
  List<String>? photos;
  User? createdBy;
  String? createdAt;
  String? updatedAt;
 
  ItemData({
    this.id,
    this.title,
    this.price,
    this.condition,
    this.status,
    this.location,
    this.photos,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
  });
 
  ItemData.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    title = json['title'];
    price = json['price'];
    condition = json['condition'];
    status = json['status'];
    location = json['location'];
    photos = json['photos'] != null ? List<String>.from(json['photos']) : [];
 
    createdBy =
        json['createdBy'] != null ? User.fromJson(json['createdBy']) : null;
 
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }
}
 
class User {
  String? id;
  String? name;
  String? email;
  String? profilePicture;
 
  User({this.id, this.name, this.email, this.profilePicture});
 
  User.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    name = json['name'];
    email = json['email'];
    profilePicture = json['profilePicture'];
  }
}