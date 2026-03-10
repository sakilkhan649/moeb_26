import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moeb_26/Core/routs.dart';
import 'package:moeb_26/Views/auth/Signup_Flow/SignupController.dart';
import 'package:moeb_26/Views/Service_Area/Controller/serviceController.dart';

class CreateAccountController extends GetxController {
  final ServiceAreaController _serviceAreaController =
      Get.isRegistered<ServiceAreaController>()
      ? Get.find<ServiceAreaController>()
      : Get.put(ServiceAreaController());

  // Text Controllers
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

  // Password visibility
  var showPassword = false.obs;
  var showConfirmPassword = false.obs;

  // Dropdown selections
  var selectedRole = ''.obs;
  var selectedArea = ''.obs;

  final roles = ['Company manager', 'Owner operator', 'Driver'];

  // Derived cities from ServiceAreaController
  List<String> get cities =>
      _serviceAreaController.serviceAreas.map((e) => e.areaName).toList();
  bool get isCitiesLoading => _serviceAreaController.isLoading.value;
  bool get isMoreCitiesLoading => _serviceAreaController.isMoreLoading.value;
  bool get hasNextCitiesPage =>
      _serviceAreaController.currentPage.value <
      _serviceAreaController.totalPages.value;

  @override
  void onInit() {
    super.onInit();
    // Fetch service areas when controller is initialized
    _serviceAreaController.fetchServiceAreas();
  }

  void loadMoreCities() {
    _serviceAreaController.loadMoreServiceAreas();
  }

  void togglePassword() => showPassword.value = !showPassword.value;
  void toggleConfirmPassword() =>
      showConfirmPassword.value = !showConfirmPassword.value;

  void pickRole(String role) {
    selectedRole.value = role;
    companyRoleController.text = role;
  }

  void pickArea(String area) {
    selectedArea.value = area;
    serviceController.text = area;
  }

  void register() {
    // Map role to backend enum
    String roleToSubmit = companyRoleController.text;
    if (roleToSubmit == 'Company manager') {
      roleToSubmit = 'MANAGER';
    } else if (roleToSubmit == 'Owner operator') {
      roleToSubmit = 'OWNER';
    } else if (roleToSubmit == 'Driver') {
      roleToSubmit = 'DRIVER';
    }

    // Save all data to SignupController
    final signupCtrl = Get.put(SignupController());
    signupCtrl.saveAccountInfo(
      name: nameController.text,
      email: emailController.text,
      password: passwordController.text,
      phone: phoneController.text,
      home: homeAddressController.text,
      serviceArea: serviceController.text,
      experience: int.tryParse(yearController.text) ?? 0,
      company: companyNameController.text,
      companyRole: roleToSubmit,
    );

    // Navigate to next step
    Get.toNamed(Routes.vehicleinformation);
  }

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    homeAddressController.dispose();
    serviceController.dispose();
    yearController.dispose();
    companyNameController.dispose();
    companyRoleController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
