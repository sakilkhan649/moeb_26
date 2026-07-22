import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:moeb_26/core/utils/media_picker_helper.dart';
import 'package:moeb_26/core/services/socket_service.dart';
import 'package:moeb_26/core/services/user_service.dart';
import 'package:moeb_26/core/utils/helpers.dart';
import 'package:moeb_26/data/models/chat_community_model.dart';
import 'package:moeb_26/data/models/chat_model.dart';

class CommunityChatDetailController extends GetxController {
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
    selectedState.value = newState;
    fetchMessages();
  }

  void setupSocket() {
    // Disabled for demo mode
  }

  Future<void> fetchMessages() async {
    try {
      isLoading.value = true;
      await Future.delayed(const Duration(milliseconds: 300));
      messages.assignAll([
        CommunityMessage(
          id: 'cmsg_5',
          serviceArea: selectedState.value,
          sender: ChatParticipant(
            id: 'user_jim',
            name: 'Jim Halpert',
            profilePicture: null,
          ),
          text: 'Is anyone heading towards Miami this weekend?',
          attachments: [],
          createdAt: DateTime.now().subtract(const Duration(minutes: 2)).toIso8601String(),
          updatedAt: DateTime.now().subtract(const Duration(minutes: 2)).toIso8601String(),
        ),
        CommunityMessage(
          id: 'cmsg_4',
          serviceArea: selectedState.value,
          sender: ChatParticipant(
            id: 'user_dwight',
            name: 'Dwight Schrute',
            profilePicture: null,
          ),
          text: 'Traffic on the main highway is really heavy today, drive safe guys.',
          attachments: [],
          createdAt: DateTime.now().subtract(const Duration(minutes: 10)).toIso8601String(),
          updatedAt: DateTime.now().subtract(const Duration(minutes: 10)).toIso8601String(),
        ),
        CommunityMessage(
          id: 'cmsg_3',
          serviceArea: selectedState.value,
          sender: ChatParticipant(
            id: 'user_michael',
            name: 'Michael Scott',
            profilePicture: null,
          ),
          text: 'Thanks Pam, I\'ll check it out right now.',
          attachments: [],
          createdAt: DateTime.now().subtract(const Duration(minutes: 15)).toIso8601String(),
          updatedAt: DateTime.now().subtract(const Duration(minutes: 15)).toIso8601String(),
        ),
        CommunityMessage(
          id: 'cmsg_2',
          serviceArea: selectedState.value,
          sender: ChatParticipant(
            id: 'user_pam',
            name: 'Pam Beesly',
            profilePicture: null,
          ),
          text: 'Yes, I saw a couple of airport runs posted in the Job Offer section.',
          attachments: [],
          createdAt: DateTime.now().subtract(const Duration(minutes: 20)).toIso8601String(),
          updatedAt: DateTime.now().subtract(const Duration(minutes: 20)).toIso8601String(),
        ),
        CommunityMessage(
          id: 'cmsg_1',
          serviceArea: selectedState.value,
          sender: ChatParticipant(
            id: 'user_michael',
            name: 'Michael Scott',
            profilePicture: null,
          ),
          text: 'Hey everyone! Is there any ride request available in Orlando today?',
          attachments: [],
          createdAt: DateTime.now().subtract(const Duration(minutes: 30)).toIso8601String(),
          updatedAt: DateTime.now().subtract(const Duration(minutes: 30)).toIso8601String(),
        ),
      ]);
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

    isSending.value = true;
    await Future.delayed(const Duration(milliseconds: 100));
    final currentUserId = userService.userId;
    
    final newMsg = CommunityMessage(
      id: 'cmsg_user_${DateTime.now().millisecondsSinceEpoch}',
      serviceArea: selectedState.value,
      sender: ChatParticipant(
        id: currentUserId,
        name: 'You',
        profilePicture: null,
      ),
      text: text,
      attachments: [],
      createdAt: DateTime.now().toIso8601String(),
      updatedAt: DateTime.now().toIso8601String(),
    );

    messages.insert(0, newMsg);
    messageController.clear();
    selectedImages.clear();
    isSending.value = false;
  }

  @override
  void onClose() {
    messageController.dispose();
    super.onClose();
  }
}
