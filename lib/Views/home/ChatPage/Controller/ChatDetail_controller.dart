import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../Ripositoryes/socket_repository.dart';
import '../../../../Services/socket_service.dart';
import '../../../../Services/user_service.dart';
import '../Model/Chat_message_model.dart';
import '../Model/Chat_model.dart';

class ChatDetailController extends GetxController {
  final SocketRepository socketRepo = Get.find();
  final SocketService socketService = Get.find();
  final UserService userService = Get.find();

  final RxList<ChatMessage> messages = <ChatMessage>[].obs;
  final TextEditingController messageController = TextEditingController();
  final RxBool isLoading = false.obs;

  late ChatPreview chat;

  @override
  void onInit() {
    super.onInit();
    chat = Get.arguments;
    fetchMessages();
    setupSocket();
  }

  void setupSocket() {
    socketService.joinRoom(chat.id);

    // Listen for new messages
    socketService.on('NEW_MESSAGE', (data) {
      if (data != null) {
        final newMessage = ChatMessage.fromJson(data);
        // Only add if it belongs to this chat and isn't already here
        if (newMessage.chatId == chat.id &&
            !messages.any((m) => m.id == newMessage.id)) {
          messages.insert(0, newMessage);
        }
      }
    });
  }

  Future<void> fetchMessages() async {
    try {
      isLoading.value = true;
      final fetchedMessages = await socketRepo.getMessages(chat.id);
      messages.assignAll(fetchedMessages);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load messages');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> sendMessage() async {
    final text = messageController.text.trim();
    if (text.isNotEmpty) {
      // ১. টেম্পোরারি মেসেজ তৈরি করে লিস্টে যোগ করা (Instant UI update)
      final tempId = DateTime.now().millisecondsSinceEpoch.toString();
      final tempMessage = ChatMessage(
        id: tempId,
        chatId: chat.id,
        text: text,
        senderId: userService.userId,
        createdAt: DateTime.now().toIso8601String(),
        updatedAt: DateTime.now().toIso8601String(),
      );

      messages.insert(0, tempMessage);
      messageController.clear();

      try {
        final sentMessage = await socketRepo.sendMessage(chat.id, text);
        if (sentMessage != null) {
          // ২. টেম্পোরারি মেসেজটি সরিয়ে সার্ভার থেকে আসা আসল মেসেজটি যোগ করা
          int index = messages.indexWhere((m) => m.id == tempId);
          if (index != -1) {
            messages[index] = sentMessage;
          } else if (!messages.any((m) => m.id == sentMessage.id)) {
            messages.insert(0, sentMessage);
          }
        }
      } catch (e) {
        // এরর হলে টেম্পোরারি মেসেজটি রিমুভ করা
        messages.removeWhere((m) => m.id == tempId);
        Get.snackbar('Error', 'Failed to send message');
      }
    }
  }

  @override
  void onClose() {
    socketService.leaveRoom(chat.id);
    socketService.off('NEW_MESSAGE');
    messageController.dispose();
    super.onClose();
  }
}
