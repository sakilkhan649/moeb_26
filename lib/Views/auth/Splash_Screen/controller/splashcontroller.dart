import 'dart:async';
import 'package:get/get.dart';
import 'package:moeb_26/Core/routs.dart';
import 'package:moeb_26/Views/auth/Create_Account_and_signIn/createscreens.dart';
import 'package:uuid/uuid.dart';

import '../../../../Config/app_constants.dart';
import '../../../../Config/storage_constants.dart';
import '../../../../Services/storege_service.dart';

class SplashScreenController extends GetxController {
  RxInt currentIndex = 0.obs; // Reactive state for dot index
  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();
    await getOrCreateDeviceToken();
    // Login check is now handled after 3 seconds in startTimer
  }

  // Start the timer and change the dot index over time
  void startTimer() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (currentIndex.value < 2) {
        currentIndex.value++; // Update the current dot index
      } else {
        timer.cancel();
      }
    });

    // After 3 seconds, check login and navigate
    Timer(const Duration(seconds: 3), () {
      checkLogin();
    });
  }

  Future<String> getOrCreateDeviceToken() async {
    String token = await StorageService.getString(StorageConstants.deviceToken);
    AppConstants.deviceToken = token;

    if (token.isEmpty) {
      token = const Uuid().v4(); // unique device token
      await StorageService.setString(StorageConstants.deviceToken, token);
    }

    return token;
  }

  Future<void> checkLogin() async {
    final accessToken = await StorageService.getString(
      StorageConstants.bearerToken,
    );
    if (accessToken.isNotEmpty) {
      Get.offAllNamed(Routes.homeScreens);
    } else {
      Get.offAll(() => const Createscreens());
    }
  }
}
