
class SupportTicket {
  final String id;
  final String subject;
  final String user;
  final List<SupportMessage> messages;
  final String createdAt;
  final String updatedAt;
  final SupportChat? chat;

  SupportTicket({
    required this.id,
    required this.subject,
    required this.user,
    required this.messages,
    required this.createdAt,
    required this.updatedAt,
    this.chat,
  });

  factory SupportTicket.fromJson(Map<String, dynamic> json) {
    return SupportTicket(
      id: json['_id'] ?? json['id'] ?? '',
      subject: json['subject'] ?? '',
      user: json['user'] ?? '',
      messages: (json['messages'] as List?)
              ?.map((i) => SupportMessage.fromJson(i))
              .toList() ??
          [],
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      chat: json['chat'] != null ? SupportChat.fromJson(json['chat']) : null,
    );
  }
}

class SupportMessage {
  final String id;
  final String sender;
  final String message;
  final String createdAt;

  SupportMessage({
    required this.id,
    required this.sender,
    required this.message,
    required this.createdAt,
  });

  factory SupportMessage.fromJson(Map<String, dynamic> json) {
    return SupportMessage(
      id: json['_id'] ?? json['id'] ?? '',
      sender: json['sender'] ?? '',
      message: json['message'] ?? '',
      createdAt: json['createdAt'] ?? '',
    );
  }
}

class SupportChat {
    final String id;
    final String supportId;

    SupportChat({
        required this.id,
        required this.supportId,
    });

    factory SupportChat.fromJson(Map<String, dynamic> json) {
        return SupportChat(
            id: json['_id'] ?? json['id'] ?? '',
            supportId: json['supportId'] ?? '',
        );
    }
}
