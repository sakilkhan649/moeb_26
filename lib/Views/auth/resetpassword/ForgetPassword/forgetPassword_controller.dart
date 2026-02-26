import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moeb_26/Services/auth_service.dart';
import '../../../../Core/routs.dart';
import '../../../../Utils/helpers.dart';

class ForgotPasswordController extends GetxController {
  final AuthService _authService = Get.find();

  final isLoading = false.obs;
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  // ─── Forgot Password ──────────────────────────────────────────
  Future<void> forgotPassword() async {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;

    try {
      final response = await _authService.forgotPassword(
        emailController.text.trim(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final message =
            response.data['message'] ??
            'Please check your email. We have sent you a one-time passcode (OTP).';

        Helpers.showCustomSnackBar(message, isError: false);

        // Navigate to OTP screen, pass email for verification
        Get.toNamed(
          Routes.forgetotpVerificationScreen, // ← তোমার OTP route দাও
          arguments: {'email': emailController.text.trim()},
        );
      }
    } catch (e) {
      Helpers.showDebugLog("forgotPassword error => $e");
      Helpers.showCustomSnackBar('Something went wrong.', isError: true);
    } finally {
      isLoading.value = false;
    }
  }

  // ─── Dispose ──────────────────────────────────────────────────
  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }
}
