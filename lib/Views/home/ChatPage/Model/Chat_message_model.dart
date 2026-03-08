import 'Chat_model.dart';

class ChatMessage {
  final String id;
  final String chatId;
  final ChatParticipant? sender;
  final String? senderId; // fallback when sender is just an ID string
  final String text;
  final String createdAt;
  final String updatedAt;

  ChatMessage({
    required this.id,
    required this.chatId,
    this.sender,
    this.senderId,
    required this.text,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    ChatParticipant? senderObj;
    String? senderIdStr;

    if (json['sender'] is Map<String, dynamic>) {
      senderObj = ChatParticipant.fromJson(json['sender']);
    } else if (json['sender'] is String) {
      senderIdStr = json['sender'];
    }

    return ChatMessage(
      id: json['_id'] ?? '',
      chatId: json['chatId'] ?? '',
      sender: senderObj,
      senderId: senderIdStr ?? senderObj?.id,
      text: json['text'] ?? '',
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }

  /// Check if this message was sent by the given userId
  bool isSentBy(String? userId) {
    if (userId == null || userId.isEmpty) return false;
    return senderId == userId || sender?.id == userId;
  }

  String get time {
    try {
      final dateTime = DateTime.parse(createdAt).toLocal();
      final hour = dateTime.hour > 12 ? dateTime.hour - 12 : dateTime.hour;
      final period = dateTime.hour >= 12 ? 'PM' : 'AM';
      final minute = dateTime.minute.toString().padLeft(2, '0');
      return '$hour:$minute $period';
    } catch (_) {
      return 'Now';
    }
  }
}
