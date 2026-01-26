// Notification Item Model - প্রতিটি notification এর data structure
class NotificationItem {
  final String icon;
  final String title;
  final String message;
  final String time;

  NotificationItem({
    required this.icon,
    required this.title,
    required this.message,
    required this.time,
  });
}