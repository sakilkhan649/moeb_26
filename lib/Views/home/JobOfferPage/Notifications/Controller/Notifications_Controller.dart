import 'package:get/get.dart';

import '../../../../../Utils/app_icons.dart';
import '../Models/Notifications_Model.dart';

class NotificationController extends GetxController {
  // Notification list - এখানে সব notifications থাকবে
  var notifications = <NotificationItem>[
    NotificationItem(
      icon: AppIcons.job_icon,
      title: "Job Acceptance",
      message: "John Smith accepted your job for JFK Airport pickup",
      time: "3h ago",
    ),
    NotificationItem(
      icon: AppIcons.message_icon,
      title: "New Message",
      message: "Elite Transportation Co. sent you a message",
      time: "3h ago",
    ),
    NotificationItem(
      icon: AppIcons.item_icon,
      title: "Item Interest",
      message: "Someone is interested in your Dashboard Camera",
      time: "3h ago",
    ),
  ].obs;

  // Unread notifications count
  int get unreadCount => notifications.length;

  // সব notifications clear করার method
  void clearAll() {
    notifications.clear();
  }

  // Single notification remove করার method
  void removeNotification(int index) {
    notifications.removeAt(index);
  }
}