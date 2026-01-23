import 'dart:async';

import 'package:get/get.dart';
import 'package:moeb_26/Views/auth/createscreens.dart';


class SplashScreenController extends GetxController {
  RxInt currentIndex = 0.obs; // Reactive state for dot index

  // Start the timer and change the dot index over time
  void startTimer() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      if (currentIndex.value < 2) {
        currentIndex.value++; // Update the current dot index
      }
    });

    // After 3 seconds, navigate to the next screen
    Timer(Duration(seconds: 3), () {
      Get.off(() => Createscreens());
    });
  }
}