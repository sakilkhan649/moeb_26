import 'dart:io';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:moeb_26/Core/routs.dart';
import 'package:moeb_26/Services/auth_service.dart';
import 'package:moeb_26/Utils/helpers.dart';
import 'package:moeb_26/Views/Service_Area/Controller/serviceController.dart';
import 'package:moeb_26/Views/auth/Vehicle/Model/VehicleModel.dart';

class SignupController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  final ImagePicker _imagePicker = ImagePicker();

  final ServiceAreaController _serviceAreaController =
      Get.isRegistered<ServiceAreaController>()
      ? Get.find<ServiceAreaController>()
      : Get.put(ServiceAreaController());

  var isLoading = false.obs;
  var showErrors = false.obs;

  // ===========================================================================
  // STEP 1: ACCOUNT INFORMATION
  // ===========================================================================
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final homeAddressController = TextEditingController();
  final yearController = TextEditingController();
  final companyNameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  var showPassword = false.obs;
  var showConfirmPassword = false.obs;
  var selectedRole = ''.obs;
  var selectedArea = ''.obs;

  final roles = ['Company manager', 'Owner operator', 'Driver'];

  // Service Area Data
  List<String> get cities => _serviceAreaController.serviceAreas
      .map((e) => e.areaName)
      .toSet()
      .toList();
  bool get isCitiesLoading => _serviceAreaController.isLoading.value;
  bool get isMoreCitiesLoading => _serviceAreaController.isMoreLoading.value;
  bool get hasNextCitiesPage =>
      _serviceAreaController.currentPage.value <
      _serviceAreaController.totalPages.value;

  void togglePassword() => showPassword.value = !showPassword.value;
  void toggleConfirmPassword() =>
      showConfirmPassword.value = !showConfirmPassword.value;

  void pickRole(String role) => selectedRole.value = role;
  void pickArea(String area) => selectedArea.value = area;

  void fetchServiceAreas() => _serviceAreaController.fetchServiceAreas();
  void loadMoreCities() => _serviceAreaController.loadMoreServiceAreas();

  // ===========================================================================
  // STEP 2: VEHICLE INFORMATION
  // ===========================================================================
  final RxList<VehicleModel> vehiclesList = <VehicleModel>[VehicleModel()].obs;

  void addVehicle() => vehiclesList.add(VehicleModel());
  void removeVehicle(int index) {
    if (vehiclesList.length > 1) {
      vehiclesList[index].dispose();
      vehiclesList.removeAt(index);
    }
  }

  // ===========================================================================
  // STEP 3: DOCUMENTS UPLOAD
  // ===========================================================================
  final Rx<File?> licensePlateFile = Rx<File?>(null);
  final Rx<File?> hackLicenseFile = Rx<File?>(null);
  final Rx<File?> localPermitFile = Rx<File?>(null);
  final Rx<File?> headshotFile = Rx<File?>(null);
  final Rx<File?> profilePictureFile = Rx<File?>(null);

  final licensePlateExpireController = TextEditingController();
  final hackLicenseExpireController = TextEditingController();
  final localPermitExpireController = TextEditingController();

  // ===========================================================================
  // STEP 4: TERMS & POLICY
  // ===========================================================================
  final RxList<bool> termChecks = List.generate(63, (_) => false).obs;
  final RxBool showTermError = false.obs;

  void toggleTermCheck(int index) {
    termChecks[index] = !termChecks[index];
    if (allTermsChecked) showTermError.value = false;
  }

  bool get allTermsChecked => termChecks.every((e) => e);

  // ===========================================================================
  // HELPER METHODS (MEDIA & DATE)
  // ===========================================================================

  Future<void> selectDate(
    BuildContext context,
    TextEditingController controller,
  ) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.dark(
            primary: Color(0xFF14F195),
            onPrimary: Colors.black,
            surface: Color(0xFF1E2939),
            onSurface: Colors.white,
          ),
          dialogBackgroundColor: const Color(0xFF1E2939),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      controller.text = DateFormat('d MMMM y').format(picked);
    }
  }

  Future<void> pickFromCamera(Rx<File?> target) async {
    final XFile? image = await _imagePicker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );
    if (image != null) target.value = File(image.path);
  }

  Future<void> pickFromFile(Rx<File?> target) async {
    final FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
    );
    if (result != null && result.files.single.path != null) {
      target.value = File(result.files.single.path!);
    }
  }

  String getFileName(Rx<File?> file) {
    if (file.value == null) return '';
    return file.value!.path.split(Platform.pathSeparator).last;
  }

  // ===========================================================================
  // FINAL SUBMIT — POST /user
  // ===========================================================================
  Future<void> submitAll() async {
    if (!allTermsChecked) {
      showTermError.value = true;
      Helpers.showCustomSnackBar(
        'Please agree to all terms before continuing',
        isError: true,
      );
      return;
    }

    try {
      isLoading.value = true;

      // Map role to backend expected format
      String roleToSubmit = selectedRole.value;
      if (roleToSubmit == 'Company manager') {
        roleToSubmit = 'MANAGER';
        // ignore: curly_braces_in_flow_control_structures
      } else if (roleToSubmit == 'Owner operator')
        // ignore: curly_braces_in_flow_control_structures
        roleToSubmit = 'OWNER';
      // ignore: curly_braces_in_flow_control_structures
      else if (roleToSubmit == 'Driver')
        // ignore: curly_braces_in_flow_control_structures
        roleToSubmit = 'DRIVER';

      final response = await _authService.signup(
        name: nameController.text,
        email: emailController.text,
        password: passwordController.text,
        phone: phoneController.text,
        home: homeAddressController.text,
        serviceArea: selectedArea.value,
        experience: int.tryParse(yearController.text) ?? 0,
        company: companyNameController.text,
        companyRole: roleToSubmit,
        vehicles: vehiclesList.toList(),
        drivingLicenseFile: licensePlateFile.value!,
        drivingLicenseExpiry: licensePlateExpireController.text,
        hackLicenseFile: hackLicenseFile.value!,
        hackLicenseExpiry: hackLicenseExpireController.text,
        localPermitFile: localPermitFile.value,
        localPermitExpiry: localPermitExpireController.text.isEmpty
            ? null
            : localPermitExpireController.text,
        headshotFile: headshotFile.value!,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Helpers.showCustomSnackBar('Registration successful', isError: false);
        Get.toNamed(
          Routes.otpVerificationScreen,
          arguments: {'email': emailController.text, 'isRegister': true},
        );
      } else {
        final message = response.data is Map
            ? (response.data['message'] ?? 'Registration failed.')
            : 'Registration failed.';
        Helpers.showCustomSnackBar(message, isError: true);
      }
    } on DioException catch (e) {
      final message = e.response?.data['message'] ?? 'Registration failed.';
      Helpers.showCustomSnackBar(message, isError: true);
    } catch (e) {
      Helpers.showCustomSnackBar('Something went wrong.', isError: true);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    homeAddressController.dispose();
    yearController.dispose();
    companyNameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    licensePlateExpireController.dispose();
    hackLicenseExpireController.dispose();
    localPermitExpireController.dispose();
    for (var v in vehiclesList) {
      v.dispose();
    }
    super.onClose();
  }
}
