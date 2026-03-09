import 'package:get/get.dart';
import '../../../../../Services/notifications_service.dart';
import '../Models/Notifications_Model.dart';

class NotificationController extends GetxController {
  final NotificationsService _notificationsService = Get.put(
    NotificationsService(),
  );

  var notifications = <NotificationItem>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
  }

  // Unread notifications count
  int get unreadCount => notifications.where((n) => !n.isRead).length;

  Future<void> fetchNotifications() async {
    try {
      isLoading.value = true;
      final response = await _notificationsService.getMyNotifications();

      if (response.statusCode == 200 || response.statusCode == 201) {
        final List<dynamic>? data = response.data['data'];
        if (data != null) {
          final items = data
              .map((json) => NotificationItem.fromJson(json))
              .toList();
          notifications.assignAll(items);
        }
      }
    } catch (e) {
      print("Error fetching notifications: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // সব notifications clear করার method (Mark all as read)
  Future<void> markAllAsRead() async {
    try {
      final response = await _notificationsService.markAllAsRead();
      if (response.statusCode == 200 || response.statusCode == 201) {
        // Refresh local list
        fetchNotifications();
      }
    } catch (e) {
      print("Error marking all as read: $e");
    }
  }

  // Single notification mark as read করার method
  Future<void> markAsRead(String notificationId) async {
    try {
      final response = await _notificationsService.markAsRead(notificationId);
      if (response.statusCode == 200 || response.statusCode == 201) {
        // Find and update locally or just refetch
        int index = notifications.indexWhere((n) => n.id == notificationId);
        if (index != -1) {
          // You might need a copyWith or just update the list
          fetchNotifications();
        }
      }
    } catch (e) {
      print("Error marking notification as read: $e");
    }
  }

  // Single notification remove করার method (If API supports delete)
  void removeNotification(int index) {
    // Currently using mock remove if API not available
    notifications.removeAt(index);
  }
}
