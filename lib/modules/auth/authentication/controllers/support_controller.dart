import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moeb_26/config/routes/app_pages.dart';
import 'package:moeb_26/core/services/support_service.dart';
import 'package:moeb_26/core/utils/helpers.dart';
import 'package:moeb_26/core/utils/media_picker_helper.dart';

class SupportController extends GetxController {
  final SupportService _supportService = Get.find<SupportService>();

  final RxList tickets = [].obs;
  final RxBool isLoading = false.obs;
  final RxBool isSubmitting = false.obs;

  final subjectController = TextEditingController();
  final messageController = TextEditingController();
  final RxList<File> selectedFiles = <File>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchMyTickets();
  }

  Future<void> fetchMyTickets() async {
    try {
      isLoading.value = true;
      final response = await _supportService.getMyTickets();
      if (response.statusCode == 200 || response.statusCode == 201) {
        tickets.assignAll(response.data['data'] ?? []);
      }
    } catch (e) {
      debugPrint("Error fetching tickets: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> pickAttachment(BuildContext context) async {
    try {
      final File? file = await MediaPickerHelper.showImageOrPdfPicker(context);
      if (file != null) {
        selectedFiles.add(file);
      }
    } catch (e) {
      debugPrint("Error picking attachment: $e");
    }
  }

  void removeAttachment(int index) {
    if (index >= 0 && index < selectedFiles.length) {
      selectedFiles.removeAt(index);
    }
  }

  Future<void> createSupportTicket() async {
    if (subjectController.text.isEmpty || messageController.text.isEmpty) {
      Helpers.showCustomSnackBar("Please fill all fields", isError: true);
      return;
    }

    try {
      isSubmitting.value = true;
      final response = await _supportService.createSupport(
        subject: subjectController.text,
        message: messageController.text,
        attachments: selectedFiles,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Helpers.showCustomSnackBar(
          "Support request sent successfully",
          isError: false,
        );
        subjectController.clear();
        messageController.clear();
        selectedFiles.clear();
        await fetchMyTickets(); // Refresh list
        Get.back(); // Go back to previous screen
      }
    } catch (e) {
      Helpers.showCustomSnackBar(
        "Failed to send support request",
        isError: true,
      );
    } finally {
      isSubmitting.value = false;
    }
  }

  void handleTicketTap(dynamic ticket) {
    if (ticket['chat'] == null) {
      Helpers.showCustomSnackBar(
        "Admin has not yet created a chat, please wait.",
        isError: true,
      );
    } else {
      final String chatId = ticket['chat']['_id'] ?? ticket['chat']['id'];
      final String userId = ticket['user']?.toString() ?? '';
      Get.toNamed(
        Routes.chatSupportDetailView,
        arguments: {'chatId': chatId, 'userId': userId},
      );
    }
  }

  @override
  void onClose() {
    subjectController.dispose();
    messageController.dispose();
    super.onClose();
  }
}
