import 'dart:async';
import 'package:get/get.dart';
import 'package:moeb_26/config/constants/app_constants.dart';
import 'package:moeb_26/config/constants/storage_constants.dart';
import 'package:moeb_26/config/routes/app_pages.dart';
import 'package:moeb_26/modules/auth/authentication/views/auth_selection_view.dart';
import 'package:moeb_26/core/services/storege_service.dart';

class SplashScreenController extends GetxController {
  RxInt currentIndex = 0.obs; // Reactive state for dot index
  Timer? _periodicTimer;
  Timer? _navigationTimer;

  @override
  void onInit() {
    super.onInit();
    _initAsync();
  }

  Future<void> _initAsync() async {
    AppConstants.fcmToken = await StorageService.getString(
      StorageConstants.fcmToken,
    );
  }

  // Start the timer and change the dot index over time
  void startTimer() {
    _periodicTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (currentIndex.value < 2) {
        currentIndex.value++; // Update the current dot index
      } else {
        timer.cancel();
      }
    });

    // After 3 seconds, check login and navigate
    _navigationTimer = Timer(const Duration(seconds: 3), () {
      checkLogin();
    });
  }

  Future<void> checkLogin() async {
    final accessToken = await StorageService.getString(
      StorageConstants.bearerToken,
    );
    if (accessToken.isNotEmpty) {
      Get.offAllNamed(Routes.bottomNabbarView);
    } else {
      Get.offAll(() => const AuthSelectionView());
    }
  }

  @override
  void onClose() {
    _periodicTimer?.cancel();
    _navigationTimer?.cancel();
    super.onClose();
  }
}
