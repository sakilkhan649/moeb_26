import 'package:dio/dio.dart';
import '../Config/api_constants.dart';
import '../Services/api_client.dart';

class SupportRepo {
  final ApiClient apiClient;
  SupportRepo({required this.apiClient});

  /// ===================== GET MY TICKETS =====================
  Future<Response> getMyTickets() async {
    return await apiClient.getData(ApiConstants.myTickets);
  }

  /// ===================== CREATE SUPPORT TICKET =====================
  Future<Response> createSupport({
    required String subject,
    required String message,
  }) async {
    return await apiClient.postData(ApiConstants.createSupport, {
      "subject": subject,
      "message": message,
    });
  }
}
