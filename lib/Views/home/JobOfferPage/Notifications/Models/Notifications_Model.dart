import '../../../../../Utils/app_icons.dart';

class NotificationItem {
  final String id;
  final String title;
  final String subtitle;
  final String type;
  final bool isRead;
  final DateTime createdAt;
  final String icon;

  NotificationItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.type,
    required this.isRead,
    required this.createdAt,
    required this.icon,
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    String type = json['type']?.toString() ?? 'GENERAL';
    String iconPath = AppIcons.job_icon; // Default

    if (type == 'GENERAL') {
      iconPath = AppIcons.job_icon;
    } else if (type == 'REMINDER') {
      iconPath = AppIcons.item_icon;
    } else if (type == 'TASK') {
      iconPath = AppIcons.message_icon;
    }

    return NotificationItem(
      id: json['_id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      subtitle: json['subtitle']?.toString() ?? '',
      type: type,
      isRead: json['read'] ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      icon: iconPath,
    );
  }

  String get timeAgo {
    final difference = DateTime.now().difference(createdAt);
    if (difference.inDays > 0) return '${difference.inDays}d ago';
    if (difference.inHours > 0) return '${difference.inHours}h ago';
    if (difference.inMinutes > 0) return '${difference.inMinutes}m ago';
    return 'Just now';
  }
}
