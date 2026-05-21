import 'package:dio/dio.dart';
import 'package:moeb_26/data/repositories/ratings_feedback_repository.dart';

class RatingsFeedbackService {
  final RatingsFeedbackRepo ratingsFeedbackRepo;

  RatingsFeedbackService({required this.ratingsFeedbackRepo});

  Future<Response> getReviews() {
    return ratingsFeedbackRepo.getReviews();
  }
}
