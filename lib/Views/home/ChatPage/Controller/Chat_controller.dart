import 'package:get/get.dart';
import '../../../../Ripositoryes/socket_repository.dart';
import '../../../../Services/socket_service.dart';
import '../../../../Services/user_service.dart';
import '../Model/Chat_model.dart';

class ChatController extends GetxController {
  final SocketRepository socketRepo = Get.find();
  final SocketService socketService = Get.find();
  
  var chats = <ChatPreview>[].obs;
  var filteredChats = <ChatPreview>[].obs;
  var searchController = "".obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchChats();
    setupRealtimeUpdates();
  }

  void setupRealtimeUpdates() {
    // Listen for global message updates to refresh the list
    ever(socketService.lastReceivedMessage, (newMessage) {
      if (newMessage != null) {
        // Find if this chat exists in our list
        int index = chats.indexWhere((c) => c.id == newMessage.chatId);
        if (index != -1) {
          // Update the chat preview and move to top
          final updatedChat = chats[index];
          updatedChat.lastMessage = newMessage.text;
          updatedChat.lastMessageAt = newMessage.createdAt;
          // You might want to update unread count here if needed
          
          chats.removeAt(index);
          chats.insert(0, updatedChat);
          filterChats(searchController.value);
        } else {
          // If it's a new chat not in list, fetch all again
          fetchChats();
        }
      }
    });
  }

  Future<void> fetchChats() async {
    try {
      isLoading.value = true;
      final fetchedChats = await socketRepo.getChats();
      chats.assignAll(fetchedChats);
      filteredChats.assignAll(chats);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load chats');
    } finally {
      isLoading.value = false;
    }
  }

  void filterChats(String query) {
    searchController.value = query;
    if (query.isEmpty) {
      filteredChats.assignAll(chats);
    } else {
      filteredChats.assignAll(
        chats.where((chat) {
          final currentUserId = Get.find<UserService>().userId;
          final other = chat.getOtherParticipant(currentUserId);
          return other?.name.toLowerCase().contains(query.toLowerCase()) ?? false;
        }).toList(),
      );
    }
  }
}

