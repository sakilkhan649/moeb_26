import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moeb_26/Services/auth_service.dart';
import 'package:moeb_26/widgets/Custom_snacbar.dart' as Helpers;

class ChangePasswordController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

  final TextEditingController currentPasswordController =
      TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  var isCurrentPasswordVisible = false.obs;
  var isNewPasswordVisible = false.obs;
  var isConfirmPasswordVisible = false.obs;

  var isLoading = false.obs;

  @override
  void onClose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  Future<void> changePassword() async {
    try {
      isLoading.value = true;
      final response = await _authService.changePassword(
        currentPassword: currentPasswordController.text.trim(),
        newPassword: newPasswordController.text.trim(),
        confirmPassword: confirmPasswordController.text.trim(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final message = response.data is Map
            ? (response.data['message'] ?? 'Password changed successfully.')
            : 'Password changed successfully.';
        Helpers.showCustomSnackBar(message, isError: false);
        Navigator.pop(Get.context!);
      } else {
        final message = response.data is Map
            ? (response.data['message'] ?? 'Failed to change password.')
            : 'Failed to change password.';
        Helpers.showCustomSnackBar(message, isError: true);
      }
    } on DioException catch (e) {
      final message =
          e.response?.data['message'] ?? 'Failed to change password.';
      Helpers.showCustomSnackBar(message, isError: true);
    } catch (e) {
      Helpers.showCustomSnackBar('Something went wrong.', isError: true);
    } finally {
      isLoading.value = false;
    }
  }
}
