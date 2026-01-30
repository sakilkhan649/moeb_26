import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../Model/Deals_model.dart';

class DealsController extends GetxController {
  // Reactive list of deals
  final RxList<DealsItem> dealsList = <DealsItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Adding dummy data as per design
    loadDummyDeals();
  }

  void loadDummyDeals() {
    dealsList.assignAll([
      DealsItem(
        category: "Service",
        title: "20% Off Premium Car Wash",
        description:
            "Get your vehicle professionally detailed at Elite Auto Spa",
        promoCode: "ELITE20",
        expiryDate: "Feb 15",
      ),
      DealsItem(
        category: "Technology",
        title: "Free Month of Dashcam Cloud Storage",
        description: "Sign up for BlackVue Cloud and get first month free",
        promoCode: "DASH1FREE",
        expiryDate: "Jan 31",
      ),
      DealsItem(
        category: "Insurance",
        title: "\$50 Off Insurance Premium",
        description:
            "Special rate for Elite Network members on commercial insurance",
        promoCode: "INSURANCE50",
        expiryDate: "Mar 1",
      ),
    ]);
  }

  // Clear deals to test empty state
  void clearDeals() {
    dealsList.clear();
  }

  // Copy promo code to clipboard
  void copyToClipboard(String code) {
    Clipboard.setData(ClipboardData(text: code));
    Get.snackbar(
      "Success",
      "Promo code $code copied to clipboard",
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }
}
