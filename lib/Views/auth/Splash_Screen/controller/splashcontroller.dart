import 'dart:async';
import 'package:get/get.dart';
import 'package:moeb_26/Views/auth/Create_Account_and_signIn/createscreens.dart';
import 'package:uuid/uuid.dart';

import '../../../../Config/app_constants.dart';
import '../../../../Config/storage_constants.dart';
import '../../../../Services/storege_service.dart';

class SplashScreenController extends GetxController {
  RxInt currentIndex = 0.obs; // Reactive state for dot index
  @override
  void onInit() async{
    // TODO: implement onInit
    super.onInit();
   await getOrCreateDeviceToken();
  }

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

  Future<String> getOrCreateDeviceToken() async {
    String token = await StorageService.getString(StorageConstants.deviceToken);
    AppConstants.deviceToken = token;

    if (token.isEmpty) {
      token = const Uuid().v4(); // unique device token
      await StorageService.setString(StorageConstants.deviceToken, token);
    }

    return token;
  }
}
