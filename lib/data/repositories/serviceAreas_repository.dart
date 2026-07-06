import 'package:dio/dio.dart';
import 'package:moeb_26/config/constants/api_constants.dart';
import 'package:moeb_26/core/services/api_client.dart';

class ServiceAreasRepo {
  final ApiClient apiClient;

  ServiceAreasRepo({required this.apiClient});

  Future<Response> getAllServiceAreas({int page = 1, int limit = 10}) async {
    return await apiClient.getData(
      ApiConstants.serviceAreas,
      query: {'page': page, 'limit': limit},
    );
  }

  Future<Response> updateServiceArea(String areaName) async {
    return await apiClient.patchData(ApiConstants.profile, {
      'serviceArea': areaName,
    });
  }
}
