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
  var otpError = ''.obs;
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
    FocusManager.instance.primaryFocus?.unfocus();
    otpError.value = '';
    final bool isFormValid = formKey.currentState?.validate() ?? false;
    final otpStr = pinController.text.trim();

    if (!isFormValid || otpStr.length < 6) {
      return;
    }

    final otpCode = int.tryParse(otpStr);
    if (otpCode == null) {
      otpError.value = 'Invalid OTP format';
      return;
    }

    try {
      isLoading.value = true;
      final response = await _authService.verifyOtp(email: email, otp: otpCode);

      if (response.statusCode == 200 || response.statusCode == 201) {
        Helpers.showCustomSnackBar(
          response.data?['message'] ?? 'Email verified successfully',
          isError: false,
        );

        final resData = response.data?['data'];
        final dynamic isAccountSetupComplete =
            resData?['isOnboard'];

        FocusManager.instance.primaryFocus?.unfocus();
        await Future.delayed(const Duration(milliseconds: 100));

        if (isAccountSetupComplete == false) {
          Get.offAllNamed(Routes.vehicleinformationView);
        } else {
          Get.offAllNamed(Routes.bottomNabbarView);
        }
      } else {
        final msg = response.data?['message'] ?? 'OTP verification failed';
        otpError.value = msg;
      }
    } catch (e) {
      Helpers.error('OTP verification error: $e');
      otpError.value = 'OTP verification failed. Please try again.';
    } finally {
      isLoading.value = false;
    }
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
