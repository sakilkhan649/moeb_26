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

  /// Create chat with a participant for a job
  Future<ChatPreview?> createChat(String participantId, String jobId) async {
    try {
      final response = await apiClient.postData(ApiConstants.chats, {
        'participantId': participantId,
        'jobId': jobId,
      });
      if (response.statusCode == 200 || response.statusCode == 201) {
        return ChatPreview.fromJson(response.data['data']);
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 409) {
        // Chat already exists, fetch the chat list to find it
        final chats = await getChats();
        try {
          // Look for a chat that has this participantId and matches jobId
          // If no specific jobId match found, fallback to just participantId
          return chats.firstWhere(
            (chat) => 
              chat.participants.any((p) => p.id == participantId) && 
              chat.jobId == jobId,
            orElse: () => chats.firstWhere(
              (chat) => chat.participants.any((p) => p.id == participantId)
            ),
          );
        } catch (_) {
          // If not found in the list, rethrow the original error
          rethrow;
        }
      }
      rethrow;
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
    } on DioException catch (e) {
      if (e.response?.statusCode == 409) {
        // Chat already exists, fetch the chat list to find it
        final chats = await getChats();
        try {
          // Look for a chat that has this participantId and matches itemId
          // Fallback to participantId only if itemId doesn't match
          return chats.firstWhere(
            (chat) => 
              chat.participants.any((p) => p.id == participantId) && 
              chat.item?.id == itemId,
            orElse: () => chats.firstWhere(
              (chat) => chat.participants.any((p) => p.id == participantId)
            ),
          );
        } catch (_) {
          rethrow;
        }
      }
      rethrow;
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
  /// Delete a chat
  Future<Response> deleteChat(String chatId) async {
    try {
      final url = ApiConstants.chatsId.replaceAll('{{chatId}}', chatId);
      final response = await apiClient.deleteData(url);
      return response;
    } catch (e) {
      rethrow;
    }
  }

}
