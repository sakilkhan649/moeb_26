import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moeb_26/Services/auth_service.dart';
import '../../../../Core/routs.dart';
import '../../../../Utils/helpers.dart';

class LoginController extends GetxController {
  final AuthService _authService = Get.find();

  final isLoading = false.obs;
  final isPasswordVisible = false.obs;
  final errorMessage = ''.obs;
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // ─── Toggle Password Visibility ──────────────────────────────
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  // ─── Login ───────────────────────────────────────────────────
  Future<void> login() async {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;

    try {
      final response = await _authService.login(
        email: emailController.text,
        password: passwordController.text,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Helpers.showCustomSnackBar('Login successful', isError: false);
        Get.offAllNamed(Routes.homeScreens);
      } else {
        final String errorMsg = response.data is Map
            ? (response.data['message'] ?? 'Invalid email or password')
            : 'Invalid email or password';

        if (errorMsg.toLowerCase().contains('pending approval')) {
          Get.toNamed(Routes.homeScreens);
        } else {
          Helpers.showCustomSnackBar(errorMsg, isError: true);
        }
      }
    } catch (e) {
      Helpers.showDebugLog("login error => $e");
      Helpers.showCustomSnackBar('Something went wrong', isError: true);
    } finally {
      isLoading.value = false;
    }
  }

  // ─── Dispose ─────────────────────────────────────────────────
  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}