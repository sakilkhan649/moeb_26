import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get.dart';
import '../../../../../Core/routs.dart';

class RideCompletedController extends GetxController {
  final RxInt rating = 0.obs;
  final RxString feedback = "".obs;
  final TextEditingController feedbackController = TextEditingController();

  void updateRating(int value) {
    rating.value = value;
  }

  void submitReview() {
    // Navigate back to HomeScreens with arguments for tab selection
    Get.offAllNamed(
      Routes.homeScreens,
      arguments: {
        'bottomIndex': 1, // Rides Tab
        'ridesTab': 1, // Past Tab
      },
    );
  }

  void skipReview() {
    Get.back();
  }

  @override
  void onClose() {
    feedbackController.dispose();
    super.onClose();
  }
}
