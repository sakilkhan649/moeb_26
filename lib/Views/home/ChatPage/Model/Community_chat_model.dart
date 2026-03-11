import 'Chat_model.dart';

class CommunityRoom {
  final String name;
  final String serviceArea;
  final String? lastMessage;
  final String? lastMessageAt;

  CommunityRoom({
    required this.name,
    required this.serviceArea,
    this.lastMessage,
    this.lastMessageAt,
  });

  factory CommunityRoom.fromJson(Map<String, dynamic> json) {
    return CommunityRoom(
      name: json['name'] ?? '',
      serviceArea: json['serviceArea'] ?? '',
      lastMessage: json['lastMessage'],
      lastMessageAt: json['lastMessageAt'],
    );
  }
}

class CommunityMessage {
  final String id;
  final String serviceArea;
  final ChatParticipant sender;
  final String text;
  final List<String> attachments;
  final String createdAt;
  final String updatedAt;

  CommunityMessage({
    required this.id,
    required this.serviceArea,
    required this.sender,
    required this.text,
    required this.attachments,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CommunityMessage.fromJson(Map<String, dynamic> json) {
    return CommunityMessage(
      id: json['_id'] ?? '',
      serviceArea: json['serviceArea'] ?? '',
      sender: ChatParticipant.fromJson(json['sender'] ?? {}),
      text: json['text'] ?? '',
      attachments: List<String>.from(json['attachments'] ?? []),
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
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
