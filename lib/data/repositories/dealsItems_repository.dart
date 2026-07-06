import 'package:dio/dio.dart';
import 'package:moeb_26/config/constants/api_constants.dart';
import 'package:moeb_26/core/services/api_client.dart';

class DealsRepo {
  final ApiClient apiClient;
  DealsRepo({required this.apiClient});

  Future<Response> getActiveDeals({int page = 1, int limit = 10}) async {
    return await apiClient.getData(
      ApiConstants.dealsItems,
      query: {'page': page, 'limit': limit},
    );
  }
}
