import 'package:dio/dio.dart';
import '../Config/api_constants.dart';
import '../Services/api_client.dart';

class UserRepo {
  final ApiClient apiClient;
  UserRepo({required this.apiClient});

  Future<Response> updateProfile({
    required List<Map<String, dynamic>> vehicles,
  }) async {
    return await apiClient.patchData(
      ApiConstants.updateProfile,
      {"vehicles": vehicles},
    );
  }
}