import 'package:moeb_26/core/services/storege_service.dart';
import 'package:flutter/material.dart';
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
  final UserService userService = Get.find();

  var chats = <ChatPreview>[].obs;
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
    setupRealtimeUpdates();
  }

  Future<void> fetchCommunityRoom({String? serviceArea}) async {
    try {
      final String targetArea = serviceArea ??
          await StorageService.getString('selected_community_service_area');
      final response = await communityService.getCommunityRoom(
        serviceArea: targetArea.isNotEmpty ? targetArea : null,
      );
      if (response.statusCode == 200 && response.data != null) {
        communityRoom.value = CommunityRoom.fromJson(response.data['data']);
        return;
      }
    } catch (e) {
      debugPrint('Error fetching community room: $e');
    }

    // Default Live Chat tile info
    communityRoom.value = CommunityRoom(
      name: "Live Chat",
      serviceArea: "Global",
      lastMessage: "Welcome to the live chat room!",
      lastMessageAt: null,
    );
  }

  void markChatAsRead(String chatId) {
    int index = chats.indexWhere((c) => c.id == chatId);
    if (index != -1 && (!chats[index].isRead || chats[index].unreadCount > 0)) {
      chats[index].isRead = true;
      chats[index].unreadCount = 0;
      chats.refresh();
    }
  }

  void markCommunityAsRead() {
    if (communityRoom.value != null &&
        (!communityRoom.value!.isRead || communityRoom.value!.unreadCount > 0)) {
      final current = communityRoom.value!;
      communityRoom.value = CommunityRoom(
        name: current.name,
        serviceArea: current.serviceArea,
        totalMembers: current.totalMembers,
        lastMessage: current.lastMessage,
        lastMessageAt: current.lastMessageAt,
        unreadCount: 0,
        isRead: true,
      );
    }
  }

  void setupRealtimeUpdates() {
    // Listen for global message updates to refresh the list
    ever(socketService.lastReceivedMessage, (newMessage) {
      if (newMessage != null) {
        // Find if this chat exists in our list
        int index = chats.indexWhere((c) => c.id == newMessage.chatId);
        if (index != -1) {
          final updatedChat = chats[index];
          updatedChat.lastMessage = newMessage.text;
          updatedChat.lastMessageAt = newMessage.createdAt;

          // If the user is currently viewing this exact chat, keep it marked as READ
          final bool isCurrentlyViewing =
              socketService.activeChatId == newMessage.chatId;

          if (isCurrentlyViewing) {
            updatedChat.isRead = true;
            updatedChat.unreadCount = 0;
          } else if (newMessage.sender?.id != null &&
              newMessage.sender!.id != userService.userId) {
            updatedChat.isRead = false;
            updatedChat.unreadCount = updatedChat.unreadCount + 1;
          }

          chats.removeAt(index);
          chats.insert(0, updatedChat);
          chats.refresh();
        } else {
          // If it's a new chat not in list, fetch all again
          fetchChats();
        }
      }
    });

    // Listen for community messages
    ever(socketService.lastReceivedCommunityMessage, (newCommMsg) {
      if (newCommMsg != null && communityRoom.value != null) {
        final currentRoom = communityRoom.value!;
        String? text;
        String? createdAt;
        String? senderId;

        if (newCommMsg is Map) {
          if (newCommMsg['message'] is Map) {
            text = newCommMsg['message']['text']?.toString();
            createdAt = newCommMsg['message']['createdAt']?.toString();
            final sData = newCommMsg['message']['sender'];
            if (sData is Map) {
              senderId = sData['id']?.toString() ?? sData['_id']?.toString();
            } else if (sData is String) {
              senderId = sData;
            }
          } else {
            text = newCommMsg['text']?.toString();
            createdAt = newCommMsg['createdAt']?.toString();
            final sData = newCommMsg['sender'];
            if (sData is Map) {
              senderId = sData['id']?.toString() ?? sData['_id']?.toString();
            } else if (sData is String) {
              senderId = sData;
            }
          }
        }

        if (text != null && text.isNotEmpty) {
          final isFromOther =
              senderId != null && senderId != userService.userId;
          final isCurrentlyViewingCommunity = socketService.isCommunityActive;

          communityRoom.value = CommunityRoom(
            name: currentRoom.name,
            serviceArea: currentRoom.serviceArea,
            totalMembers: currentRoom.totalMembers,
            lastMessage: text,
            lastMessageAt: createdAt ?? DateTime.now().toIso8601String(),
            unreadCount: (isFromOther && !isCurrentlyViewingCommunity)
                ? (currentRoom.unreadCount + 1)
                : 0,
            isRead: isCurrentlyViewingCommunity
                ? true
                : (isFromOther ? false : currentRoom.isRead),
          );
        }
      }
    });
  }

  Future<void> fetchChats() async {
    try {
      isLoading.value = true;
      final result = await socketRepo.getChats();
      chats.assignAll(result);
      filterChats(searchController.value);
    } catch (e) {
      debugPrint('Error fetching chats from API: $e');
    } finally {
      isLoading.value = false;
    }
  }

  List<ChatPreview> get filteredChats {
    final query = searchController.value.trim().toLowerCase();
    if (query.isEmpty) return chats;
    final currentUserId = userService.userId;
    return chats.where((chat) {
      final other = chat.getOtherParticipant(currentUserId);
      return other?.name.toLowerCase().contains(query) ?? false;
    }).toList();
  }

  void filterChats(String query) {
    searchController.value = query;
  }

  Future<void> deleteChat(String chatId) async {
    try {
      isLoading.value = true;
      await socketRepo.deleteChat(chatId);
      chats.removeWhere((c) => c.id == chatId);
      filterChats(searchController.value);
      selectedChatIdForDelete.value = "";
      if (Get.isDialogOpen ?? false) Get.back();
      Get.snackbar(
        'Success',
        'Chat deleted successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFFEDB9B),
        colorText: Colors.black,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      debugPrint('Error deleting chat: $e');
      Get.snackbar(
        'Error',
        'Failed to delete chat',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
