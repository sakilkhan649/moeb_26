class RatingsModel {
  final ReviewSummary reviewSummary;
  final List<Review> reviews;

  RatingsModel({required this.reviewSummary, required this.reviews});

  factory RatingsModel.fromJson(Map<String, dynamic> json) {
    return RatingsModel(
      reviewSummary: ReviewSummary.fromJson(json['reviewSummary'] ?? {}),
      reviews:
          (json['reviews'] as List?)?.map((e) => Review.fromJson(e)).toList() ??
          [],
    );
  }
}

class ReviewSummary {
  final double averageRating;
  final int totalReviews;

  ReviewSummary({required this.averageRating, required this.totalReviews});

  factory ReviewSummary.fromJson(Map<String, dynamic> json) {
    return ReviewSummary(
      averageRating: (json['averageRating'] ?? 0).toDouble(),
      totalReviews: json['totalReviews'] ?? 0,
    );
  }
}

class Review {
  final String id;
  final int rating;
  final String comment;
  final String reviewerName;
  final String reviewerImage;
  final DateTime createdAt;

  Review({
    required this.id,
    required this.rating,
    required this.comment,
    required this.reviewerName,
    required this.reviewerImage,
    required this.createdAt,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['_id'] ?? '',
      rating: json['rating'] ?? 0,
      comment: json['comment'] ?? '',
      reviewerName: json['user']?['name'] ?? 'User',
      reviewerImage: json['user']?['profilePicture'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }
}
