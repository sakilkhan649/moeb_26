import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateAccountController extends GetxController {
  // Form key

  // Text Controllers - এইগুলা দিয়ে input নিব
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final serviceController = TextEditingController();
  final yearController = TextEditingController();
  final companyNameController = TextEditingController();
  final companyRoleController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // Password দেখাবো কি লুকাবো
  var showPassword = false.obs;
  var showConfirmPassword = false.obs;

  // কোন role select করছে
  var selectedRole = ''.obs;

  // কোন area select করছে
  var selectedArea = ''.obs;

  // Role এর list
  final roles = [
    'Company manager',
    'Owner operator',
    'Driver',
    'Dispatcher',
  ];

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
