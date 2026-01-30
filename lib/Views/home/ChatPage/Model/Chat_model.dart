class ChatPreview {
  final String name;
  final String lastMessage;
  final String time;
  final int unreadCount;
  final String? avatarPath;
  final String? initials;

  ChatPreview({
    required this.name,
    required this.lastMessage,
    required this.time,
    this.unreadCount = 0,
    this.avatarPath,
    this.initials,
  });
}
