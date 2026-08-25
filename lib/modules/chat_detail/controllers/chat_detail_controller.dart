import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  final Rxn<ChatMessage> replyingTo = Rxn<ChatMessage>();
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
    if (userService.userId.isEmpty) {
      await userService.fetchUserId();
    }
    fetchMessages();
  }

  void setupSocket() {
    debugPrint(
      '🔄 ChatDetailController: Setting up socket for room: chat::${chat.id}',
    );
    socketService.joinRoom('chat::${chat.id}');

    _messageWorker = ever(socketService.lastReceivedMessage, (newMessage) {
      if (newMessage != null && newMessage.text.trim().isNotEmpty) {
        if (newMessage.chatId == chat.id) {
          int tempIndex = messages.indexWhere((m) => m.id.startsWith('temp_'));

          if (tempIndex != -1 && newMessage.isSentBy(userService.userId)) {
            messages[tempIndex] = newMessage;
          } else if (!messages.any((m) => m.id == newMessage.id)) {
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
      if (fetchedMessages.length > 1) {
        final firstDate = DateTime.tryParse(fetchedMessages.first.createdAt);
        final lastDate = DateTime.tryParse(fetchedMessages.last.createdAt);
        if (firstDate != null && lastDate != null && firstDate.isBefore(lastDate)) {
          messages.assignAll(fetchedMessages.reversed.toList());
        } else {
          messages.assignAll(fetchedMessages);
        }
      } else {
        messages.assignAll(fetchedMessages);
      }
      update();
    } catch (e) {
      debugPrint('Error fetching messages: $e');
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

  void replyToMessage(ChatMessage message) {
    replyingTo.value = message;
  }

  void cancelReply() {
    replyingTo.value = null;
  }

  void copyMessage(ChatMessage message) {
    final regex = RegExp(r'^\[REPLY:([^|]*)\|([^\]]*)\]([\s\S]*)$');
    final match = regex.firstMatch(message.text);
    final String cleanText = match != null
        ? (match.group(3) ?? '')
        : message.text;

    Clipboard.setData(ClipboardData(text: cleanText));
    Helpers.showCustomSnackBar('Message copied to clipboard', isError: false);
  }

  Future<void> sendMessage() async {
    var text = messageController.text.trim();
    if (text.isNotEmpty || selectedImages.isNotEmpty) {
      if (replyingTo.value != null) {
        final replyText = replyingTo.value!.text;
        final cleanReplyText = replyText.startsWith('[REPLY:')
            ? replyText.split(']').skip(1).join(']')
            : replyText;
        final senderName = replyingTo.value!.isSentBy(userService.userId)
            ? 'You'
            : (replyingTo.value!.sender?.name ?? 'Someone');
        text = '[REPLY:$senderName|$cleanReplyText]$text';
        replyingTo.value = null;
      }

      final tempId = 'temp_${DateTime.now().millisecondsSinceEpoch}';

      final List<File> imagesToSend = selectedImages.toList();
      selectedImages.clear();

      final tempMessage = ChatMessage(
        id: tempId,
        chatId: chat.id,
        text: text,
        senderId: userService.userId,
        sender: ChatParticipant(id: userService.userId, name: 'You'),
        createdAt: DateTime.now().toIso8601String(),
        updatedAt: DateTime.now().toIso8601String(),
      );

      messages.insert(0, tempMessage);
      messageController.clear();

      try {
        final sentMessage = await socketRepo.sendMessage(
          chat.id,
          text,
          attachments: imagesToSend,
        );
        if (sentMessage != null) {
          int index = messages.indexWhere((m) => m.id == tempId);
          if (index != -1) {
            messages[index] = sentMessage;
          }
        }
      } catch (e) {
        messages.removeWhere((m) => m.id == tempId);
        selectedImages.addAll(imagesToSend);
        Get.snackbar(
          'Error',
          'Failed to send message',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
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
