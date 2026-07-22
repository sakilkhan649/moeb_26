import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:moeb_26/core/utils/media_picker_helper.dart';
import 'package:moeb_26/core/utils/helpers.dart';
import 'package:moeb_26/data/models/chat_model.dart';
import 'package:moeb_26/data/models/chat_message_model.dart';
import 'package:moeb_26/data/repositories/socket_repository.dart';
import 'package:moeb_26/core/services/socket_service.dart';
import 'package:moeb_26/core/services/user_service.dart';

class ChatDetailController extends GetxController {
  final SocketRepository socketRepo = Get.find();
  final SocketService socketService = Get.find();
  final UserService userService = Get.find();

  final RxList<ChatMessage> messages = <ChatMessage>[].obs;
  final TextEditingController messageController = TextEditingController();
  final RxBool isLoading = false.obs;
  final RxList<File> selectedImages = <File>[].obs;
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
    if (chat.id.startsWith('demo_')) {
      return;
    }
    debugPrint(
      '🔄 ChatDetailController: Setting up socket for room: chat::${chat.id}',
    );
    socketService.joinRoom('chat::${chat.id}');

    // Listen for global message updates
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
    if (chat.id.startsWith('demo_')) {
      try {
        isLoading.value = true;
        await Future.delayed(const Duration(milliseconds: 300));
        if (chat.id == 'demo_admin_chat') {
          messages.assignAll([
            ChatMessage(
              id: 'msg_admin_1',
              chatId: chat.id,
              text: 'Hello! Let us know if you have any questions.',
              senderId: 'admin_id',
              sender: ChatParticipant(id: 'admin_id', name: 'Ekkali Support'),
              createdAt: DateTime.now()
                  .subtract(const Duration(minutes: 5))
                  .toIso8601String(),
              updatedAt: DateTime.now()
                  .subtract(const Duration(minutes: 5))
                  .toIso8601String(),
            ),
            ChatMessage(
              id: 'msg_admin_0',
              chatId: chat.id,
              text: 'Welcome to Moeb 26! How can we assist you today?',
              senderId: 'admin_id',
              sender: ChatParticipant(id: 'admin_id', name: 'Ekkali Support'),
              createdAt: DateTime.now()
                  .subtract(const Duration(minutes: 10))
                  .toIso8601String(),
              updatedAt: DateTime.now()
                  .subtract(const Duration(minutes: 10))
                  .toIso8601String(),
            ),
          ]);
        } else if (chat.id == 'demo_user_chat_1') {
          messages.assignAll([
            ChatMessage(
              id: 'msg_user_1',
              chatId: chat.id,
              text: 'Hey, is the offer still available?',
              senderId: 'demo_user_id_1',
              sender: ChatParticipant(id: 'demo_user_id_1', name: 'John Doe'),
              createdAt: DateTime.now()
                  .subtract(const Duration(hours: 2))
                  .toIso8601String(),
              updatedAt: DateTime.now()
                  .subtract(const Duration(hours: 2))
                  .toIso8601String(),
            ),
            ChatMessage(
              id: 'msg_user_0',
              chatId: chat.id,
              text: 'Hello there!',
              senderId: 'demo_user_id_1',
              sender: ChatParticipant(id: 'demo_user_id_1', name: 'John Doe'),
              createdAt: DateTime.now()
                  .subtract(const Duration(hours: 2, minutes: 5))
                  .toIso8601String(),
              updatedAt: DateTime.now()
                  .subtract(const Duration(hours: 2, minutes: 5))
                  .toIso8601String(),
            ),
          ]);
        } else if (chat.id == 'demo_user_chat_2') {
          messages.assignAll([
            ChatMessage(
              id: 'msg_user_2_1',
              chatId: chat.id,
              text: 'I am interested in this vehicle listing.',
              senderId: 'demo_user_id_2',
              sender: ChatParticipant(id: 'demo_user_id_2', name: 'Jane Smith'),
              createdAt: DateTime.now()
                  .subtract(const Duration(days: 1))
                  .toIso8601String(),
              updatedAt: DateTime.now()
                  .subtract(const Duration(days: 1))
                  .toIso8601String(),
            ),
            ChatMessage(
              id: 'msg_user_2_0',
              chatId: chat.id,
              text: 'Hi, can you give me more details?',
              senderId: 'demo_user_id_2',
              sender: ChatParticipant(id: 'demo_user_id_2', name: 'Jane Smith'),
              createdAt: DateTime.now()
                  .subtract(const Duration(days: 1, hours: 1))
                  .toIso8601String(),
              updatedAt: DateTime.now()
                  .subtract(const Duration(days: 1, hours: 1))
                  .toIso8601String(),
            ),
          ]);
        }
      } catch (_) {
      } finally {
        isLoading.value = false;
      }
      return;
    }

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

  Future<void> pickImage(BuildContext context) async {
    final List<File>? images = await MediaPickerHelper.pickMultiImages(context);
    if (images != null && images.isNotEmpty) {
      for (var image in images) {
        final compressed = await Helpers.compressImage(image);
        selectedImages.add(compressed);
      }
    }
  }

  Future<void> takePhoto() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );
      if (image != null) {
        final compressed = await Helpers.compressImage(File(image.path));
        selectedImages.add(compressed);
      }
    } catch (e) {
      Helpers.error('Error picking from camera: $e');
      Helpers.showCustomSnackBar(
        'Could not open camera. Please check app permissions in settings.',
        isError: true,
      );
    }
  }

  void removeImage(int index) {
    selectedImages.removeAt(index);
  }

  Future<void> sendMessage() async {
    final text = messageController.text.trim();
    if (text.isNotEmpty || selectedImages.isNotEmpty) {
      final tempId = 'temp_${DateTime.now().millisecondsSinceEpoch}';

      final List<File> imagesToSend = selectedImages.toList();
      selectedImages.clear();

      // sender object সহ tempMessage বানাও
      final tempMessage = ChatMessage(
        id: tempId,
        chatId: chat.id,
        text: text,
        senderId: userService.userId,
        sender: ChatParticipant(id: userService.userId, name: ''),
        createdAt: DateTime.now().toIso8601String(),
        updatedAt: DateTime.now().toIso8601String(),
      );

      messages.insert(0, tempMessage);
      messageController.clear();

      if (chat.id.startsWith('demo_')) {
        await Future.delayed(const Duration(milliseconds: 200));
        int index = messages.indexWhere((m) => m.id == tempId);
        if (index != -1) {
          messages[index] = ChatMessage(
            id: 'demo_sent_${DateTime.now().millisecondsSinceEpoch}',
            chatId: chat.id,
            text: text,
            senderId: userService.userId,
            sender: ChatParticipant(id: userService.userId, name: 'You'),
            createdAt: DateTime.now().toIso8601String(),
            updatedAt: DateTime.now().toIso8601String(),
          );
        }
        return;
      }

      try {
        final sentMessage = await socketRepo.sendMessage(
          chat.id,
          text,
          attachments: imagesToSend,
        );
        if (sentMessage != null) {
          // tempId দিয়ে খুঁজে replace করো
          int index = messages.indexWhere((m) => m.id == tempId);
          if (index != -1) {
            messages[index] = sentMessage;
          }
        }
      } catch (e) {
        messages.removeWhere((m) => m.id == tempId);
        selectedImages.addAll(imagesToSend);
        Get.snackbar('Error', 'Failed to send message');
      }
    }
  }

  @override
  void onClose() {
    socketService.leaveRoom('chat::${chat.id}');
    _messageWorker?.dispose();
    messageController.dispose();
    super.onClose();
  }
}
