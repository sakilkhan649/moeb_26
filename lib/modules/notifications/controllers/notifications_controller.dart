import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:moeb_26/config/constants/icon_paths.dart';
import 'package:moeb_26/core/services/notifications_service.dart';
import 'package:moeb_26/data/models/Notifications_Model.dart';

class NotificationController extends GetxController {
  final NotificationsService _notificationsService =
      Get.find<NotificationsService>();

  var notifications = <NotificationItem>[].obs;
  var isLoading = false.obs;

  final RxList<String> mutedIds = <String>[].obs;
  final RxList<String> deletedIds = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadMuteAndDeletedStates().then((_) => fetchNotifications());
  }

  Future<void> loadMuteAndDeletedStates() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      mutedIds.assignAll(prefs.getStringList('muted_notifications') ?? []);
      deletedIds.assignAll(prefs.getStringList('deleted_notifications') ?? []);
    } catch (e) {
      debugPrint("Error loading mute/delete states: $e");
    }
  }

  bool isMuted(String id) => mutedIds.contains(id);
  bool isDeleted(String id) => deletedIds.contains(id);

  Future<void> toggleMuteNotification(String id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (mutedIds.contains(id)) {
        mutedIds.remove(id);
      } else {
        mutedIds.add(id);
      }
      await prefs.setStringList('muted_notifications', mutedIds);
      notifications.refresh();
    } catch (e) {
      debugPrint("Error toggling mute: $e");
    }
  }

  Future<void> deleteNotification(String id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      deletedIds.add(id);
      await prefs.setStringList('deleted_notifications', deletedIds);
      // Remove locally from the active list
      notifications.removeWhere((n) => n.id == id);
      // Call DELETE on API if needed, fallback gracefully
      try {
        await _notificationsService.deleteNotification(id);
      } catch (_) {}
    } catch (e) {
      debugPrint("Error deleting notification: $e");
    }
  }

  // Unread notifications count (excluding muted notifications)
  int get unreadCount =>
      notifications.where((n) => !n.isRead && !isMuted(n.id)).length;

  List<NotificationItem> _getDemoNotifications() {
    final list = [
      NotificationItem(
        id: "demo_1",
        title: "Job Acceptance",
        subtitle: "Your chauffeur request has been accepted. View details.",
        type: "TASK",
        isRead: false,
        createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
        icon: AppIcons.job_icon,
      ),
      NotificationItem(
        id: "demo_2",
        title: "New Message from Support",
        subtitle:
            "Hello, we have updated your ride details. Press to open support chat.",
        type: "MESSAGE",
        isRead: false,
        createdAt: DateTime.now().subtract(const Duration(hours: 1)),
        icon: AppIcons.message_icon,
      ),
      NotificationItem(
        id: "demo_3",
        title: "Exclusive Savings Deal",
        subtitle:
            "Get 20% off on your next chauffeur booking in Miami service area.",
        type: "REMINDER",
        isRead: true,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        icon: AppIcons.deals_icon,
      ),
      NotificationItem(
        id: "demo_4",
        title: "New Invoice #INV-8729",
        subtitle: "A payment request has been issued for your recent ride.",
        type: "GENERAL",
        isRead: false,
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        icon: AppIcons.job_icon,
      ),
    ];
    // Filter out deleted ones
    return list.where((n) => !deletedIds.contains(n.id)).toList();
  }

  Future<void> fetchNotifications() async {
    try {
      isLoading.value = true;
      final response = await _notificationsService.getMyNotifications();

      if (response.statusCode == 200 || response.statusCode == 201) {
        final List<dynamic>? data = response.data['data'];
        if (data != null) {
          final items = data
              .map((json) => NotificationItem.fromJson(json))
              .where((n) => !deletedIds.contains(n.id))
              .toList();
          notifications.assignAll(items);
        }
      }
    } catch (e) {
      debugPrint("Error fetching notifications: $e");
    } finally {
      isLoading.value = false;
      // Always add manually defined demo notifications if they are not deleted
      final demoList = _getDemoNotifications();
      final currentList = notifications.toList();
      for (var demo in demoList) {
        if (!currentList.any((n) => n.id == demo.id)) {
          currentList.add(demo);
        }
      }
      notifications.assignAll(currentList);
    }
  }

  // সব notifications clear করার method (Mark all as read)
  Future<void> markAllAsRead() async {
    try {
      final response = await _notificationsService.markAllAsRead();
      if (response.statusCode == 200 || response.statusCode == 201) {
        // Update local list directly for instant UI feedback
        for (var i = 0; i < notifications.length; i++) {
          notifications[i] = NotificationItem(
            id: notifications[i].id,
            title: notifications[i].title,
            subtitle: notifications[i].subtitle,
            type: notifications[i].type,
            isRead: true,
            createdAt: notifications[i].createdAt,
            icon: notifications[i].icon,
          );
        }
        notifications.refresh();
      }
    } catch (e) {
      debugPrint("Error marking all as read: $e");
    }
  }

  // Single notification mark as read করার method
  Future<void> markAsRead(String notificationId) async {
    try {
      final response = await _notificationsService.markAsRead(notificationId);
      if (response.statusCode == 200 || response.statusCode == 201) {
        // Find and update locally
        int index = notifications.indexWhere((n) => n.id == notificationId);
        if (index != -1) {
          notifications[index] = NotificationItem(
            id: notifications[index].id,
            title: notifications[index].title,
            subtitle: notifications[index].subtitle,
            type: notifications[index].type,
            isRead: true,
            createdAt: notifications[index].createdAt,
            icon: notifications[index].icon,
          );
          notifications.refresh();
        }
      }
    } catch (e) {
      debugPrint("Error marking notification as read: $e");
    }
  }

  // Single notification remove করার method (If API supports delete)
  void removeNotification(int index) {
    // Currently using mock remove if API not available
    notifications.removeAt(index);
  }
}
