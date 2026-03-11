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
  Worker? _messageWorker;

  late ChatPreview chat;

  @override
  void onInit() {
    super.onInit();
    chat = Get.arguments;
    _initWithUserId();
    setupSocket();
  }

  Future<void> _initWithUserId() async {
    // userId না থাকলে fetch হওয়া পর্যন্ত wait করো
    if (userService.userId.isEmpty) {
      await userService.fetchUserId();
    }
    fetchMessages();
  }
  void setupSocket() {
    socketService.joinRoom(chat.id);

    _messageWorker = ever(socketService.lastReceivedMessage, (newMessage) {
      if (newMessage != null && newMessage.text.trim().isNotEmpty) {
        if (newMessage.chatId == chat.id) {

          // temp message আছে কিনা চেক করো
          int tempIndex = messages.indexWhere((m) => m.id.startsWith('temp_'));

          if (tempIndex != -1 && newMessage.isSentBy(userService.userId)) {
            // temp replace করো real message দিয়ে
            messages[tempIndex] = newMessage;
          } else if (!messages.any((m) => m.id == newMessage.id)) {
            // অন্যের message add করো
            messages.insert(0, newMessage);
          }
        }
      }
    });
  }

  Future<void> fetchMessages() async {
    try {
      isLoading.value = true;
      final fetchedMessages = await socketRepo.getMessages(chat.id);
      messages.assignAll(fetchedMessages);
      update();
    } catch (e) {
      Get.snackbar('Error', 'Failed to load messages');
    } finally {
      isLoading.value = false;
    }
  }
  Future<void> sendMessage() async {
    final text = messageController.text.trim();
    if (text.isNotEmpty) {
      final tempId = 'temp_${DateTime.now().millisecondsSinceEpoch}';

      // sender object সহ tempMessage বানাও
      final tempMessage = ChatMessage(
        id: tempId,
        chatId: chat.id,
        text: text,
        senderId: userService.userId,
        sender: ChatParticipant(
          id: userService.userId,
          name:'',
        ),
        createdAt: DateTime.now().toIso8601String(),
        updatedAt: DateTime.now().toIso8601String(),
      );

      messages.insert(0, tempMessage);
      messageController.clear();

      try {
        final sentMessage = await socketRepo.sendMessage(chat.id, text);
        if (sentMessage != null) {
          // tempId দিয়ে খুঁজে replace করো
          int index = messages.indexWhere((m) => m.id == tempId);
          if (index != -1) {
            messages[index] = sentMessage;
          }
        }
      } catch (e) {
        messages.removeWhere((m) => m.id == tempId);
        Get.snackbar('Error', 'Failed to send message');
      }
    }
  }

  @override
  void onClose() {
    socketService.leaveRoom(chat.id);
    _messageWorker?.dispose();
    messageController.dispose();
    super.onClose();
  }
}
