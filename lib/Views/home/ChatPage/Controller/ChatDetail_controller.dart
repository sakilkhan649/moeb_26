import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Model/Chat_message_model.dart';

class ChatDetailController extends GetxController {
  final RxList<ChatMessage> messages = <ChatMessage>[].obs;
  final TextEditingController messageController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    loadDummyMessages();
  }

  void loadDummyMessages() {
    messages.assignAll([
      ChatMessage(
        text: "Hi! I accepted your job for tomorrow.",
        time: "10:15 AM",
        isSender: false,
      ),
      ChatMessage(
        text:
            "Perfect! Thanks for accepting. I will send you the exact pickup location.",
        time: "10:18 AM",
        isSender: true,
      ),
      ChatMessage(
        text: "JFK Airport, Terminal 4, Gate 12. Client arrives at 2:30 PM.",
        time: "10:20 AM",
        isSender: true,
      ),
      ChatMessage(
        text: "Perfect, see you at 2:30 PM",
        time: "10:30 AM",
        isSender: false,
      ),
    ]);
  }

  void sendMessage() {
    if (messageController.text.trim().isNotEmpty) {
      messages.add(
        ChatMessage(
          text: messageController.text.trim(),
          time: "Now", // In a real app, use formatting
          isSender: true,
        ),
      );
      messageController.clear();
      update();
    }
  }

  @override
  void onClose() {
    messageController.dispose();
    super.onClose();
  }
}
