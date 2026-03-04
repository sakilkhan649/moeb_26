import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../../Services/dealsItems_service.dart';
import '../Model/Deals_model.dart';

class DealsController extends GetxController {
  final DealsService _dealsService = Get.put(DealsService());

  // Reactive list of deals
  final RxList<DealsItem> dealsList = <DealsItem>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchDeals();
  }

  Future<void> fetchDeals() async {
    try {
      isLoading.value = true;
      final response = await _dealsService.getActiveDeals();

      if (response.statusCode == 200 || response.statusCode == 201) {
        final List<dynamic> data = response.data['data'];
        final items = data.map((json) => DealsItem.fromJson(json)).toList();
        dealsList.assignAll(items);
      }
    } catch (e) {
      print("Error fetching deals: $e");
      Get.snackbar(
        "Error",
        "Failed to fetch deals",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Copy promo code to clipboard
  void copyToClipboard(String code) {
    Clipboard.setData(ClipboardData(text: code));
    Get.snackbar(
      "Success",
      "Promo code $code copied to clipboard",
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
      backgroundColor: const Color(0xff1A1A1A),
      colorText: Colors.white,
    );
  }
}
