import 'package:dio/dio.dart';
import '../../Config/api_constants.dart';
import '../Services/api_client.dart';

class UserProfileRepo {
  final ApiClient apiClient;

  UserProfileRepo({required this.apiClient});

  Future<Response> getUserProfile() {
    return apiClient.getData(ApiConstants.userProfile);
  }
}
