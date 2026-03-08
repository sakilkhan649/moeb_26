class ChatParticipant {
  final String id;
  final String name;
  final String? email;
  final String? profilePicture;

  ChatParticipant({
    required this.id,
    required this.name,
    this.email,
    this.profilePicture,
  });

  factory ChatParticipant.fromJson(Map<String, dynamic> json) {
    return ChatParticipant(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'],
      profilePicture: json['profilePicture'],
    );
  }

  /// Get initials from the name (first letter of first two words)
  String get initials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }
}

class ChatItem {
  final String id;
  final String title;
  final double price;
  final String? condition;
  final String? status;
  final String? location;
  final List<String> photos;

  ChatItem({
    required this.id,
    required this.title,
    required this.price,
    this.condition,
    this.status,
    this.location,
    this.photos = const [],
  });

  factory ChatItem.fromJson(Map<String, dynamic> json) {
    return ChatItem(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      condition: json['condition'],
      status: json['status'],
      location: json['location'],
      photos: json['photos'] != null ? List<String>.from(json['photos']) : [],
    );
  }
}

class ChatPreview {
  final String id;
  final List<ChatParticipant> participants;
  final ChatItem? item;
  String? lastMessage;
  String? lastMessageAt;
  final String createdBy;
  final String createdAt;
  final String updatedAt;

  ChatPreview({
    required this.id,
    required this.participants,
    this.item,
    this.lastMessage,
    this.lastMessageAt,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ChatPreview.fromJson(Map<String, dynamic> json) {
    return ChatPreview(
      id: json['_id'] ?? '',
      participants: json['participants'] != null
          ? (json['participants'] as List)
                .map((p) => ChatParticipant.fromJson(p))
                .toList()
          : [],
      item: json['itemId'] != null && json['itemId'] is Map
          ? ChatItem.fromJson(json['itemId'])
          : null,
      lastMessage: json['lastMessage'],
      lastMessageAt: json['lastMessageAt'],
      createdBy: json['createdBy'] ?? '',
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }

  /// Get the "other" participant (not the current user)
  ChatParticipant? getOtherParticipant(String currentUserId) {
    try {
      return participants.firstWhere((p) => p.id != currentUserId);
    } catch (_) {
      return participants.isNotEmpty ? participants.first : null;
    }
  }
}
