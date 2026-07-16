import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:moeb_26/core/utils/media_picker_helper.dart';
import 'package:moeb_26/core/services/community_service.dart';
import 'package:moeb_26/core/services/socket_service.dart';
import 'package:moeb_26/core/services/user_service.dart';
import 'package:moeb_26/core/utils/helpers.dart';
import 'package:moeb_26/data/models/chat_community_model.dart';

class CommunityChatDetailController extends GetxController {
  final CommunityService _communityService = Get.find<CommunityService>();
  final UserService userService = Get.find<UserService>();
  final SocketService socketService = Get.find<SocketService>();

  final RxList<CommunityMessage> messages = <CommunityMessage>[].obs;
  final TextEditingController messageController = TextEditingController();
  final RxBool isLoading = false.obs;
  final RxBool isSending = false.obs;
  final RxList<File> selectedImages = <File>[].obs;

  late CommunityRoom room;
  var selectedState = 'Florida'.obs;

  final List<String> states = [
    'Florida', 'California', 'Texas', 'New York', 'Illinois', 'District of Columbia',
    'Nevada', 'Massachusetts', 'Georgia', 'Washington', 'Colorado', 'Arizona',
    'Pennsylvania', 'North Carolina', 'Tennessee', 'Minnesota', 'Louisiana', 'Utah',
    'Oregon', 'Michigan', 'Missouri', 'Ohio', 'Indiana', 'Virginia', 'South Carolina',
    'Connecticut'
  ];

  @override
  void onInit() {
    super.onInit();
    room = Get.arguments;
    // Set initial state matching Florida, California, Texas, etc.
    if (room.serviceArea != null && room.serviceArea.isNotEmpty) {
      final String area = room.serviceArea.toLowerCase();
      for (var state in states) {
        if (area.contains(state.toLowerCase())) {
          selectedState.value = state;
          break;
        }
      }
    }
    fetchMessages();
    setupSocket();
  }

  void changeState(String newState) {
    if (selectedState.value == newState) return;
    socketService.leaveRoom('community::${selectedState.value.toLowerCase()}');
    selectedState.value = newState;
    socketService.joinRoom('community::${newState.toLowerCase()}');
    fetchMessages();
  }

  void setupSocket() {
    socketService.joinRoom('community::${selectedState.value.toLowerCase()}');

    ever(socketService.lastReceivedCommunityMessage, (data) {
      if (data != null) {
        debugPrint(
          '📥 CommunityChatDetailController: Received community message update',
        );
        fetchMessages();
      }
    });
  }

  Future<void> fetchMessages() async {
    try {
      isLoading.value = true;
      final response = await _communityService.getCommunityMessages(
        serviceArea: selectedState.value,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final List data = response.data['data'] ?? [];
        messages.assignAll(
          data.map((m) => CommunityMessage.fromJson(m)).toList(),
        );
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load community messages');
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
    socketService.leaveRoom('community::${selectedState.value.toLowerCase()}');
    messageController.dispose();
    super.onClose();
  }
}
