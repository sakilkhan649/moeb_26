import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moeb_26/Core/routs.dart';
import 'package:moeb_26/Services/auth_service.dart';
import 'package:moeb_26/widgets/Custom_snacbar.dart' as Helpers;

class OtpController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

  final pinController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  var isLoading = false.obs;
  var remainingSeconds = 30.obs;
  var canResend = false.obs;
  Timer? _timer;

  String email = ''; // 👈 final সরিয়ে empty রাখো
  bool isRegister = false;


  @override
  void onInit() {
    super.onInit();
    email = Get.arguments?['email'] ?? ''; // 👈 onInit এ assign
    isRegister = Get.arguments?['isRegister'] ?? false;
    print('=====> EMAIL: $email');
    startTimer();
  }

  void startTimer() {
    remainingSeconds.value = 600;
    canResend.value = false;
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

      if (response.statusCode == 200) {
        Helpers.showCustomSnackBar('OTP Verified Successfully', isError: false);

        if(isRegister){
          Get.offAllNamed(Routes.vehicleinformation);
        }else{
          Get.offAllNamed(Routes.resetpasswordthree);
        }

      }
    } catch (e) {
      Helpers.showCustomSnackBar('You provided wrong OTP');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> resendOtp() async {
    if (!canResend.value) return;
    try {
      isLoading.value = true;
      await _authService.resendOtp(email);
      Helpers.showCustomSnackBar('OTP Resent Successfully', isError: false);
      pinController.clear();
      startTimer();
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