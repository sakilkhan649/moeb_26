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
    if (!formKey.currentState!.validate()) return;

    try {
      isLoading.value = true;

      final response = await _authService.verifyOtp(
        email: email,
        otp: int.parse(pinController.text),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        print('=====> RESPONSE DATA: ${response.data}');
        Helpers.showCustomSnackBar('OTP Verified Successfully', isError: false);

        if (isRegister) {
          final data = response.data;
          final authData = data != null ? (data['data'] ?? data) : {};
          final bool isSetupComplete = authData['account_setup_complete'] == true ||
              authData['isAccountSetupCompleted'] == true ||
              authData['is_setup_complete'] == true;

          if (isSetupComplete) {
            Get.offAllNamed(Routes.bottomNabbarView);
          } else {
            Get.offAllNamed(Routes.vehicleinformationView);
          }
        } else {
          final resetToken = response.data['data'];
          Get.toNamed(
            Routes.resetpasswordthreeView,
            arguments: {'resetToken': resetToken},
          );
        }
      } else {
        Helpers.showCustomSnackBar(
          response.statusMessage ?? 'You provided wrong OTP',
        );
      }
    } catch (e) {
      if (isRegister) {
        // Fallback during backend transition: redirect to account setup
        Get.offAllNamed(Routes.vehicleinformationView);
      } else {
        Helpers.showCustomSnackBar('You provided wrong OTP');
      }
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
