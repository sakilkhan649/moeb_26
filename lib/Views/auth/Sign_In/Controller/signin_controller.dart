import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:moeb_26/Services/api_cheker.dart';
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
        final data = response.data;
        final authData = data['data'] ?? {};
        
        // Check if user is restricted
        if (authData['isRestricted'] == true) {
          final blockReason = authData['blockReason']?.toString() ?? "Incomplete documents or vehicle not meeting standards";
          
          Helpers.showCustomSnackBar('Account Restricted', isError: true);
          
          Get.toNamed(
            Routes.applicationNotApproved,
            arguments: {
              "title": "Account Restricted",
              "description": "Unfortunately, your account access has been restricted.",
              "reason": blockReason,
            },
          );
          return;
        }

        Helpers.showCustomSnackBar('Login successful', isError: false);
        Get.offAllNamed(Routes.homeScreens);
      }
    } catch (e) {
      if (e is DioException) {
        final status = e.response?.statusCode ?? 0;
        final data = e.response?.data;
        final String errorMsg = (data is Map && data['message'] != null)
            ? data['message'].toString()
            : 'Invalid email or password';

        if (status == 400) {
          Helpers.showCustomSnackBar(errorMsg, isError: true);
        } else {
          Helpers.showCustomSnackBar('Something went wrong', isError: true);
        }
      } else {
        Helpers.showCustomSnackBar('Something went wrong', isError: true);
      }
      Helpers.showDebugLog("login error => $e");
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
