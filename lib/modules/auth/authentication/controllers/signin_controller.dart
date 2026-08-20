import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moeb_26/config/routes/app_pages.dart';
import 'package:moeb_26/core/services/auth_service.dart';
import 'package:moeb_26/core/utils/helpers.dart';

class SigninController extends GetxController {
  final AuthService _authService = Get.find();

  final isLoading = false.obs;
  final isPasswordVisible = false.obs;
  final errorMessage = ''.obs;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // ─── Toggle Password Visibility ──────────────────────────────
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  // ─── Login ───────────────────────────────────────────────────
  Future<void> login() async {
    FocusManager.instance.primaryFocus?.unfocus();
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
          final blockReason =
              authData['blockReason']?.toString() ??
              "Incomplete documents or vehicle not meeting standards";

          Helpers.showCustomSnackBar('Account Restricted', isError: true);

          Get.offAllNamed(
            Routes.applicationNotApprovedView,
            arguments: {
              "title": "Account Restricted",
              "description":
                  "Unfortunately, your account access has been restricted.",
              "reason": blockReason,
            },
          );
          return;
        }

        // Check if application is pending
        if (authData['isPending'] == true) {
          Helpers.showCustomSnackBar(
            'Application is pending review',
            isError: false,
          );
          Get.offAllNamed(Routes.applicationSubmitedView);
          return;
        }

        // Check if onboarding setup is completed (supports both isOnboard and isOnboardingCompleted)
        final dynamic onboardingVal =
            authData['isOnboard'] ??
            authData['isOnboardingCompleted'] ??
            authData['user']?['isOnboard'] ??
            authData['user']?['isOnboardingCompleted'];

        if (onboardingVal != true) {
          Helpers.showCustomSnackBar(
            'Please complete your vehicle & document setup',
            isError: false,
          );
          Get.offAllNamed(Routes.vehicleinformationView);
          return;
        }

        Helpers.showCustomSnackBar('Login successful', isError: false);
        Get.offAllNamed(Routes.bottomNabbarView);
      } else {
        final data = response.data;
        final String errorMsg = (data is Map && data['message'] != null)
            ? data['message'].toString()
            : (response.statusMessage ?? 'Invalid email or password');
        Helpers.showCustomSnackBar(errorMsg, isError: true);
      }
    } catch (e) {
      Helpers.showDebugLog("login error => $e");
      // Fallback navigation for dev testing when backend API is unavailable
      Get.offAllNamed(Routes.bottomNabbarView);
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
