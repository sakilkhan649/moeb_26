import 'package:dio/dio.dart';
import '../Config/api_constants.dart';
import '../Services/api_client.dart';

class RatingsFeedbackRepo {
  final ApiClient apiClient;

  RatingsFeedbackRepo({required this.apiClient});

  Future<Response> getReviews() {
    return apiClient.getData(ApiConstants.ratingsFeedback);
  }
}
