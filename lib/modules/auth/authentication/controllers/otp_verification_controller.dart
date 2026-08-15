import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moeb_26/config/routes/app_pages.dart';
import 'package:moeb_26/core/services/auth_service.dart';
import 'package:moeb_26/core/utils/helpers.dart';

class OtpController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

  final pinController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  var isLoading = false.obs;
  var remainingSeconds = 30.obs;
  var canResend = false.obs;
  Timer? _timer;

  String email = ''; // 👈 final সরিয়ে empty রাখো
  bool isRegister = false;

  @override
  void onInit() {
    super.onInit();
    email = Get.arguments?['email'] ?? ''; // 👈 onInit এ assig
    isRegister = Get.arguments?['isRegister'] ?? false;
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (remainingSeconds.value == 0) {
        canResend.value = true;
        timer.cancel();
      } else {
        remainingSeconds.value--;
      }
    });
  }

  String get timerText {
    int minutes = remainingSeconds.value ~/ 60;
    int seconds = remainingSeconds.value % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  Future<void> verifyOtp() async {
    // API verification bypassed for now — navigate directly to vehicle setup
    Get.offAllNamed(Routes.vehicleinformationView);
  }

  Future<void> resendOtp() async {
    if (!canResend.value) return;
    try {
      isLoading.value = true;
      if (isRegister) {
        await _authService.resendOtp(email);
      } else {
        await _authService.forgotPassword(email);
      }
      Helpers.showCustomSnackBar('OTP Resent Successfully', isError: false);
      pinController.clear();
    } catch (e) {
      Helpers.showCustomSnackBar(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    _timer?.cancel();
    pinController.dispose();
    super.onClose();
  }
}
