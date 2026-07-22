import 'package:get/get.dart';
import 'package:moeb_26/data/models/chat_model.dart';
import 'package:moeb_26/data/models/chat_community_model.dart';
import 'package:moeb_26/data/repositories/socket_repository.dart';
import 'package:moeb_26/core/services/community_service.dart';
import 'package:moeb_26/core/services/socket_service.dart';
import 'package:moeb_26/core/services/user_service.dart';

class ChatController extends GetxController {
  final SocketRepository socketRepo = Get.find();
  final SocketService socketService = Get.find();
  final CommunityService communityService = Get.find();

  var chats = <ChatPreview>[].obs;
  var filteredChats = <ChatPreview>[].obs;
  var communityRoom = Rxn<CommunityRoom>();
  var searchController = "".obs;
  var isLoading = false.obs;
  var selectedChatIdForDelete = "".obs;

  void toggleDeleteIcon(String chatId) {
    if (selectedChatIdForDelete.value == chatId) {
      selectedChatIdForDelete.value = "";
    } else {
      selectedChatIdForDelete.value = chatId;
    }
  }

  void clearDeleteSelection() {
    selectedChatIdForDelete.value = "";
  }

  @override
  void onInit() {
    super.onInit();
    fetchChats();
    fetchCommunityRoom();
    // setupRealtimeUpdates();
  }

  Future<void> fetchCommunityRoom() async {
    communityRoom.value = CommunityRoom(
      name: "Live Chat",
      serviceArea: "Global",
      lastMessage: "Welcome to the live chat room!",
      lastMessageAt: DateTime.now().toIso8601String(),
    );
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
    isLoading.value = true;
    final currentUserId = Get.find<UserService>().userId;
    chats.assignAll([
      ChatPreview(
        id: 'demo_admin_chat',
        participants: [
          ChatParticipant(
            id: currentUserId,
            name: 'You',
          ),
          ChatParticipant(
            id: 'admin_id',
            name: 'Ekkali Support',
            profilePicture: 'assets/images/ekkali support.png',
          ),
        ],
        lastMessage: 'Hello! Let us know if you have any questions.',
        lastMessageAt: DateTime.now().subtract(const Duration(minutes: 5)).toIso8601String(),
        createdBy: 'admin_id',
        createdAt: DateTime.now().subtract(const Duration(minutes: 5)).toIso8601String(),
        updatedAt: DateTime.now().subtract(const Duration(minutes: 5)).toIso8601String(),
      ),
      ChatPreview(
        id: 'demo_user_chat_1',
        participants: [
          ChatParticipant(
            id: currentUserId,
            name: 'You',
          ),
          ChatParticipant(
            id: 'demo_user_id_1',
            name: 'John Doe',
            profilePicture: null,
          ),
        ],
        lastMessage: 'Hey, is the offer still available?',
        lastMessageAt: DateTime.now().subtract(const Duration(hours: 2)).toIso8601String(),
        createdBy: 'demo_user_id_1',
        createdAt: DateTime.now().subtract(const Duration(hours: 2)).toIso8601String(),
        updatedAt: DateTime.now().subtract(const Duration(hours: 2)).toIso8601String(),
      ),
      ChatPreview(
        id: 'demo_user_chat_2',
        participants: [
          ChatParticipant(
            id: currentUserId,
            name: 'You',
          ),
          ChatParticipant(
            id: 'demo_user_id_2',
            name: 'Jane Smith',
            profilePicture: null,
          ),
        ],
        lastMessage: 'I am interested in this vehicle listing.',
        lastMessageAt: DateTime.now().subtract(const Duration(days: 1)).toIso8601String(),
        createdBy: 'demo_user_id_2',
        createdAt: DateTime.now().subtract(const Duration(days: 1)).toIso8601String(),
        updatedAt: DateTime.now().subtract(const Duration(days: 1)).toIso8601String(),
      ),
    ]);
    filteredChats.assignAll(chats);
    isLoading.value = false;
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
          return other?.name.toLowerCase().contains(query.toLowerCase()) ??
              false;
        }).toList(),
      );
    }
  }

  Future<void> deleteChat(String chatId) async {
    isLoading.value = true;
    chats.removeWhere((c) => c.id == chatId);
    filterChats(searchController.value);
    selectedChatIdForDelete.value = "";
    Get.back();
    isLoading.value = false;
  }
}
