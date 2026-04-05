import 'package:dio/dio.dart';
import '../../Config/api_constants.dart';
import '../Services/api_client.dart';

class UserProfileRepo {
  final ApiClient apiClient;

  UserProfileRepo({required this.apiClient});

  Future<Response> getUserProfile() {
    return apiClient.getData(ApiConstants.userProfile);
  }

  Future<Response> patchProfile(dynamic body) {
    return apiClient.patchData(ApiConstants.userProfile, body);
  }

  Future<Response> getServiceAreas() {
    return apiClient.getData(ApiConstants.serviceAreas);
  }

  Future<Response> getLegals() {
    return apiClient.getData(ApiConstants.legals);
  }

  Future<Response> getLegalBySlug(String slug) {
    return apiClient.getData(ApiConstants.legalsBySlug.replaceFirst('{{slug}}', slug));
  }

  Future<Response> deleteVehicle(String vehicleId) {
    return apiClient.deleteData(ApiConstants.deleteVehicle.replaceFirst('{{vehicleId}}', vehicleId));
  }
}
