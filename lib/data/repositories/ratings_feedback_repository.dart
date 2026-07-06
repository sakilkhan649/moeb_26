import 'package:dio/dio.dart';
import 'package:moeb_26/config/constants/api_constants.dart';
import 'package:moeb_26/core/services/api_client.dart';

class RatingsFeedbackRepo {
  final ApiClient apiClient;

  RatingsFeedbackRepo({required this.apiClient});

  Future<Response> getReviews() {
    return apiClient.getData(ApiConstants.ratingsFeedback);
  }
}
