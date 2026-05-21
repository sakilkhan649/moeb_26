import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../Services/support_service.dart';
import '../../../../Core/routs.dart';
import '../../../../Utils/helpers.dart';

class SupportController extends GetxController {
  final SupportService _supportService = Get.find<SupportService>();

  final RxList tickets = [].obs;
  final RxBool isLoading = false.obs;
  final RxBool isSubmitting = false.obs;

  final subjectController = TextEditingController();
  final messageController = TextEditingController();

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
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Helpers.showCustomSnackBar("Support request sent successfully", isError: false);
        subjectController.clear();
        messageController.clear();
        await fetchMyTickets(); // Refresh list
      }
    } catch (e) {
      Helpers.showCustomSnackBar("Failed to send support request", isError: true);
    } finally {
      isSubmitting.value = false;
    }
  }

  void handleTicketTap(dynamic ticket) {
    if (ticket['chat'] == null) {
      Helpers.showCustomSnackBar(
        "Admin has not created a chat yet, please wait.",
        isError: true,
      );
    } else {
      final String chatId = ticket['chat']['_id'] ?? ticket['chat']['id'];
      final String userId = ticket['user']?.toString() ?? '';
      Get.toNamed(
        Routes.supportChatDetailPage,
        arguments: {
          'chatId': chatId, 
          'userId': userId
        },
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
