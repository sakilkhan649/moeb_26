import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../Services/community_service.dart';
import '../../../../Services/user_service.dart';
import '../../../../Services/socket_service.dart';
import '../Model/Community_chat_model.dart';

class CommunityChatDetailController extends GetxController {
  final CommunityService _communityService = Get.find<CommunityService>();
  final UserService userService = Get.find<UserService>();
  final SocketService socketService = Get.find<SocketService>();

  final RxList<CommunityMessage> messages = <CommunityMessage>[].obs;
  final TextEditingController messageController = TextEditingController();
  final RxBool isLoading = false.obs;
  final RxBool isSending = false.obs;
  final RxList<File> selectedImages = <File>[].obs;
  final ImagePicker _picker = ImagePicker();

  late CommunityRoom room;

  @override
  void onInit() {
    super.onInit();
    room = Get.arguments;
    fetchMessages();
    setupSocket();
  }

  void setupSocket() {
    // Community chat use room joining by community::${serviceArea}
    socketService.joinRoom('community::${room.serviceArea}');

    ever(socketService.lastReceivedCommunityMessage, (data) {
      if (data != null) {
        debugPrint('📥 CommunityChatDetailController: Received community message update');
        fetchMessages(); 
      }
    });
  }

  Future<void> fetchMessages() async {
    try {
      isLoading.value = true;
      final response = await _communityService.getCommunityMessages();
      if (response.statusCode == 200 || response.statusCode == 201) {
        final List data = response.data['data'] ?? [];
        messages.assignAll(data.map((m) => CommunityMessage.fromJson(m)).toList());
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load community messages');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> pickImage() async {
    final List<XFile>? images = await _picker.pickMultiImage();
    if (images != null) {
      selectedImages.addAll(images.map((i) => File(i.path)));
    }
  }

  void removeImage(int index) {
    selectedImages.removeAt(index);
  }

  Future<void> sendMessage() async {
    final text = messageController.text.trim();
    if (text.isEmpty && selectedImages.isEmpty) return;

    try {
      isSending.value = true;
      final response = await _communityService.sendCommunityMessage(
        text: text,
        attachments: selectedImages.toList(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        messageController.clear();
        selectedImages.clear();
        fetchMessages(); // Refresh to show new message
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to send message');
    } finally {
      isSending.value = false;
    }
  }

  @override
  void onClose() {
    socketService.leaveRoom('community::${room.serviceArea}');
    messageController.dispose();
    super.onClose();
  }
}
