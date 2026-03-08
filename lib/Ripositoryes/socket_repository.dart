import 'package:dio/dio.dart';
import '../Config/api_constants.dart';
import '../Services/api_client.dart';
import '../Views/home/ChatPage/Model/Chat_model.dart';
import '../Views/home/ChatPage/Model/Chat_message_model.dart';

class SocketRepository {
  final ApiClient apiClient;

  SocketRepository({required this.apiClient});

  /// Get list of chats
  Future<List<ChatPreview>> getChats() async {
    try {
      final response = await apiClient.getData(ApiConstants.chats);
      if (response.statusCode == 200) {
        final List data = response.data['data'] ?? [];
        return data.map((json) => ChatPreview.fromJson(json)).toList();
      }
    } catch (e) {
      rethrow;
    }
    return [];
  }

  /// Get single chat by ID
  Future<ChatPreview?> getChatById(String chatId) async {
    try {
      final url = ApiConstants.chatsId.replaceAll('{{chatId}}', chatId);
      final response = await apiClient.getData(url);
      if (response.statusCode == 200) {
        return ChatPreview.fromJson(response.data['data']);
      }
    } catch (e) {
      rethrow;
    }
    return null;
  }

  /// Create or get chat with a participant for an item
  Future<ChatPreview?> contactSeller(String participantId, String itemId) async {
    try {
      final response = await apiClient.postData(ApiConstants.chats, {
        'participantId': participantId,
        'itemId': itemId,
      });
      if (response.statusCode == 200 || response.statusCode == 201) {
        return ChatPreview.fromJson(response.data['data']);
      }
    } catch (e) {
      rethrow;
    }
    return null;
  }

  /// Get messages for a chat
  Future<List<ChatMessage>> getMessages(String chatId, {int page = 1, int limit = 20}) async {
    try {
      final url = ApiConstants.messages.replaceAll('{{chatId}}', chatId);
      final response = await apiClient.getData(
        url,
        query: {'page': page, 'limit': limit, 'sort': '-createdAt'},
      );
      if (response.statusCode == 200) {
        final List data = response.data['data'] ?? [];
        return data.map((json) => ChatMessage.fromJson(json)).toList();
      }
    } catch (e) {
      rethrow;
    }
    return [];
  }

  /// Send a message
  Future<ChatMessage?> sendMessage(String chatId, String text) async {
    try {
      final url = ApiConstants.messages.replaceAll('{{chatId}}', chatId);
      final response = await apiClient.postData(url, {'text': text});
      if (response.statusCode == 200 || response.statusCode == 201) {
        return ChatMessage.fromJson(response.data['data']);
      }
    } catch (e) {
      rethrow;
    }
    return null;
  }
}
