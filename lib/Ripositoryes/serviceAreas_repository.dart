import 'package:dio/dio.dart';
import '../Config/api_constants.dart';
import '../Services/api_client.dart';

class ServiceAreasRepo {
  final ApiClient apiClient;

  ServiceAreasRepo({required this.apiClient});

  Future<Response> getAllServiceAreas() async {
    return await apiClient.getData(ApiConstants.serviceAreas);
  }
}
