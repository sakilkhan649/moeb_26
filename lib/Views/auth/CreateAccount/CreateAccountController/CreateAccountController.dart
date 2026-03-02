import 'package:dio/src/response.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import 'package:moeb_26/Core/routs.dart';
import 'package:moeb_26/Services/api_cheker.dart';
import 'package:moeb_26/Services/auth_service.dart';
import 'package:moeb_26/widgets/Custom_snacbar.dart' as Helpers;

class CreateAccountController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  // Form key

  // Text Controllers - এইগুলা দিয়ে input নিব
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final homeAddressController = TextEditingController();
  final serviceController = TextEditingController();
  final yearController = TextEditingController();
  final companyNameController = TextEditingController();
  final companyRoleController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // Password দেখাবো কি লুকাবো
  var showPassword = false.obs;
  var showConfirmPassword = false.obs;
  var isLoading = false.obs;

  // কোন role select করছে
  var selectedRole = ''.obs;

  // কোন area select করছে
  var selectedArea = ''.obs;

  // Role এর list
  final roles = ['Company manager', 'Owner operator', 'Driver',];

  // City এর list
  final cities = [
    'Miami, FL',
    'Orlando, FL',
    'Palm Beach, FL',
    'Fort Lauderdale, FL',
    'Naples, FL',
    'Tampa, FL',
  ];

  // Password দেখাও/লুকাও
  void togglePassword() {
    showPassword.value = !showPassword.value;
  }

  void toggleConfirmPassword() {
    showConfirmPassword.value = !showConfirmPassword.value;
  }

  // Role select করলে
  void pickRole(String role) {
    selectedRole.value = role;
    companyRoleController.text = role;
  }

  // Area select করলে
  void pickArea(String area) {
    selectedArea.value = area;
    serviceController.text = area;
  }

  Future<void> register() async {
    try {
      isLoading.value = true;

      // Map the selected role to backend enum values
      String roleToSubmit = companyRoleController.text;
      if (roleToSubmit == 'Company manager') {
        roleToSubmit = 'MANAGER';
      } else if (roleToSubmit == 'Owner operator') {
        roleToSubmit = 'OWNER';
      } else if (roleToSubmit == 'Driver') {
        roleToSubmit = 'DRIVER';
      }

      final Response<dynamic> response = await _authService.signup(
        name: nameController.text,
        email: emailController.text,
        password: passwordController.text,
        phone: phoneController.text,
        home: homeAddressController.text,
        serviceArea: serviceController.text,
        experience: int.parse(yearController.text),
        company: companyNameController.text,
        companyRole: roleToSubmit,
      );
      ApiChecker.checkWriteApi(response);
      if (response.statusCode == 200 || response.statusCode == 201) {
        Helpers.showCustomSnackBar('Registration successful',isError: false);
        Get.toNamed(Routes.otpVerificationScreen,arguments: {'email': emailController.text,"isRegister":true,});
      }
    } catch (e) {
      Helpers.showCustomSnackBar(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // Controller বন্ধ করার সময় memory clean করো
  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    serviceController.dispose();
    yearController.dispose();
    companyNameController.dispose();
    companyRoleController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
