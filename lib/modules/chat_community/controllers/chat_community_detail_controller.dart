import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:moeb_26/core/services/community_service.dart';
import 'package:moeb_26/core/utils/media_picker_helper.dart';
import 'package:moeb_26/core/services/socket_service.dart';
import 'package:moeb_26/core/services/user_service.dart';
import 'package:moeb_26/core/utils/helpers.dart';
import 'package:moeb_26/data/models/chat_community_model.dart';
import 'package:moeb_26/data/models/chat_model.dart';

class CommunityChatDetailController extends GetxController {
  final UserService userService = Get.find<UserService>();
  final SocketService socketService = Get.find<SocketService>();
  final CommunityService communityService = Get.find<CommunityService>();

  final RxList<CommunityMessage> messages = <CommunityMessage>[].obs;
  final TextEditingController messageController = TextEditingController();
  final RxBool isLoading = false.obs;
  final RxBool isSending = false.obs;
  final RxList<File> selectedImages = <File>[].obs;
  final Rxn<CommunityMessage> replyingTo = Rxn<CommunityMessage>();
  Worker? _commWorker;

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
    if (room.serviceArea.isNotEmpty) {
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
    socketService.leaveRoom('community::${selectedState.value}');
    selectedState.value = newState;
    socketService.joinRoom('community::$newState');
    fetchMessages();
  }

  void setupSocket() {
    final String currentArea = selectedState.value;
    debugPrint('🔄 CommunityChatDetailController: Joining socket room: community::$currentArea');
    socketService.joinRoom('community::$currentArea');
    if (room.serviceArea.isNotEmpty && room.serviceArea != currentArea) {
      socketService.joinRoom('community::${room.serviceArea}');
    }

    _commWorker = ever(socketService.lastReceivedCommunityMessage, (data) {
      if (data != null) {
        try {
          dynamic msgData = data;
          if (data is Map && data['message'] != null) {
            msgData = data['message'];
          }
          if (msgData is Map<String, dynamic>) {
            final newMsg = CommunityMessage.fromJson(msgData);
            int tempIndex = messages.indexWhere((m) => m.id.startsWith('cmsg_user_'));
            if (tempIndex != -1 && newMsg.sender.id == userService.userId) {
              messages[tempIndex] = newMsg;
            } else if (!messages.any((m) => m.id == newMsg.id)) {
              messages.insert(0, newMsg);
            }
          }
        } catch (e) {
          debugPrint('Error parsing real-time community message: $e');
        }
      }
    });
  }

  Future<void> fetchMessages() async {
    try {
      isLoading.value = true;
      final response = await communityService.getCommunityMessages(
        serviceArea: selectedState.value,
      );
      if (response.statusCode == 200 && response.data != null) {
        final List list = response.data['data'] ?? [];
        final fetched = list
            .map((item) => CommunityMessage.fromJson(item as Map<String, dynamic>))
            .toList();

        // Check if list is oldest-first (ASC)
        if (fetched.length > 1) {
          final firstDate = DateTime.tryParse(fetched.first.createdAt);
          final lastDate = DateTime.tryParse(fetched.last.createdAt);
          if (firstDate != null && lastDate != null && firstDate.isBefore(lastDate)) {
            // Reversing so newest message is at index 0 (bottom of screen in reverse ListView)
            messages.assignAll(fetched.reversed.toList());
          } else {
            messages.assignAll(fetched);
          }
        } else {
          messages.assignAll(fetched);
        }
      }
    } catch (e) {
      debugPrint('Error fetching community messages: $e');
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

  void replyToMessage(CommunityMessage message) {
    replyingTo.value = message;
  }

  void cancelReply() {
    replyingTo.value = null;
  }

  void copyMessage(CommunityMessage message) {
    final regex = RegExp(r'^\[REPLY:([^|]*)\|([^\]]*)\]([\s\S]*)$');
    final match = regex.firstMatch(message.text);
    final String cleanText = match != null ? (match.group(3) ?? '') : message.text;

    Clipboard.setData(ClipboardData(text: cleanText));
    Helpers.showCustomSnackBar('Message copied to clipboard', isError: false);
  }

  Future<void> sendMessage() async {
    var text = messageController.text.trim();
    if (text.isEmpty && selectedImages.isEmpty) return;

    if (replyingTo.value != null) {
      final replyText = replyingTo.value!.text;
      final cleanReplyText = replyText.startsWith('[REPLY:')
          ? replyText.split(']').skip(1).join(']')
          : replyText;
      final senderName = replyingTo.value!.sender.id == userService.userId
          ? 'You'
          : replyingTo.value!.sender.name;
      text = '[REPLY:$senderName|$cleanReplyText]$text';
      replyingTo.value = null;
    }

    final tempId = 'cmsg_user_${DateTime.now().millisecondsSinceEpoch}';
    final currentUserId = userService.userId;
    final List<File> imagesToSend = selectedImages.toList();

    final tempMsg = CommunityMessage(
      id: tempId,
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

    // Immediately show on UI at index 0 (bottom of screen)
    messages.insert(0, tempMsg);
    messageController.clear();
    selectedImages.clear();

    try {
      final response = await communityService.sendCommunityMessage(
        text: text,
        attachments: imagesToSend,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data != null && response.data['data'] != null) {
          final sent = CommunityMessage.fromJson(response.data['data']);
          int index = messages.indexWhere((m) => m.id == tempId);
          if (index != -1) {
            messages[index] = sent;
          }
        }
      }
    } catch (e) {
      debugPrint('Error sending community message: $e');
      messages.removeWhere((m) => m.id == tempId);
      selectedImages.addAll(imagesToSend);
      Get.snackbar(
        'Error',
        'Failed to send broadcast message',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  void onClose() {
    socketService.leaveRoom('community::${selectedState.value}');
    _commWorker?.dispose();
    messageController.dispose();
    super.onClose();
  }
}
