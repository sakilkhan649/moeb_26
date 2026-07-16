import 'package:dio/dio.dart';
import 'package:moeb_26/config/constants/api_constants.dart';
import 'package:moeb_26/core/services/api_client.dart';

class NotificationsRepo {
  final ApiClient apiClient;

  NotificationsRepo({required this.apiClient});

  Future<Response> getMyNotifications() async {
    return await apiClient.getData(ApiConstants.notifications);
  }

  Future<Response> markAllAsRead() async {
    return await apiClient.patchData(ApiConstants.notificationsReadAll, {});
  }

  Future<Response> markAsRead(String notificationId) async {
    return await apiClient.patchData(
      '${ApiConstants.notifications}/$notificationId/read',
      {},
    );
  }

  Future<Response> deleteNotification(String notificationId) async {
    return await apiClient.deleteData(
      '${ApiConstants.notifications}/$notificationId',
    );
  }
}
