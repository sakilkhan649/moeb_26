import 'package:dio/dio.dart';
import '../Config/api_constants.dart';
import '../Services/api_client.dart';

class DealsRepo {
  final ApiClient apiClient;
  DealsRepo({required this.apiClient});

  Future<Response> getActiveDeals() async {
    return await apiClient.getData(ApiConstants.dealsItems);
  }
}
