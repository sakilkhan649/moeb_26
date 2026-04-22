import 'package:dio/dio.dart';
import '../Ripositoryes/ratings_feedback_repository.dart';

class RatingsFeedbackService {
  final RatingsFeedbackRepo ratingsFeedbackRepo;

  RatingsFeedbackService({required this.ratingsFeedbackRepo});

  Future<Response> getReviews() {
    return ratingsFeedbackRepo.getReviews();
  }
}
