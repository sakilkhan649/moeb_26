import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:moeb_26/Core/routs.dart';
import 'package:moeb_26/Services/user_service.dart';
import 'package:moeb_26/widgets/Custom_snacbar.dart' as Helpers;

class DocumentsUploadController extends GetxController {
  final UserService _userService = Get.find<UserService>();
  final ImagePicker _imagePicker = ImagePicker();

  var isLoading = false.obs;

  // 👈 Vehicle screen থেকে আসা data
  List<Map<String, dynamic>> vehicles = [];

  @override
  void onInit() {
    super.onInit();
    vehicles = List<Map<String, dynamic>>.from(
      Get.arguments?['vehicles'] ?? [],
    );
  }

  // ========== Date Picker ==========
  Future<void> selectDate(
      BuildContext context,
      TextEditingController controller,
      ) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: Color(0xFF14F195),
              onPrimary: Colors.black,
              surface: Color(0xFF1E2939),
              onSurface: Colors.white,
            ),
            dialogBackgroundColor: Color(0xFF1E2939),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      controller.text = DateFormat('d MMMM y').format(picked);
    }
  }

  // ========== Document files ==========
  final Rx<File?> licensePlateFile = Rx<File?>(null);
  final Rx<File?> hackLicenseFile = Rx<File?>(null);
  final Rx<File?> localPermitFile = Rx<File?>(null);
  final Rx<File?> commercialInsuranceFile = Rx<File?>(null);
  final Rx<File?> vehicleRegistrationFile = Rx<File?>(null);
  final Rx<File?> headshotFile = Rx<File?>(null);

  // ========== Vehicle photo files ==========
  final Rx<File?> frontViewFile = Rx<File?>(null);
  final Rx<File?> rearViewFile = Rx<File?>(null);
  final Rx<File?> interiorViewFile = Rx<File?>(null);

  // ========== Expire date controllers ==========
  final licensePlateExpireController = TextEditingController();
  final hackLicenseExpireController = TextEditingController();
  final localPermitExpireController = TextEditingController();
  final commercialInsuranceExpireController = TextEditingController();
  final vehicleRegistrationExpireController = TextEditingController();

  final RxBool showErrors = false.obs;

  // ========== Pick from Camera ==========
  Future<void> pickFromCamera(Rx<File?> target) async {
    final XFile? image = await _imagePicker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );
    if (image != null) target.value = File(image.path);
  }

  // ========== Pick from File ==========
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

  bool validateDocuments() {
    return licensePlateFile.value != null &&
        hackLicenseFile.value != null &&
        commercialInsuranceFile.value != null &&
        vehicleRegistrationFile.value != null &&
        headshotFile.value != null &&
        frontViewFile.value != null &&
        rearViewFile.value != null &&
        interiorViewFile.value != null;
  }

  // ========== Submit Documents ==========
  Future<void> submitDocuments() async {
    try {
      isLoading.value = true;

      final response = await _userService.updateDocuments(
        vehicles: vehicles, // 👈 vehicles pass করো
        drivingLicense: licensePlateFile.value!,
        drivingLicenseExpire: licensePlateExpireController.text,
        hackLicense: hackLicenseFile.value!,
        hackLicenseExpire: hackLicenseExpireController.text,
        localPermit: localPermitFile.value,
        localPermitExpire: localPermitExpireController.text.isEmpty
            ? null
            : localPermitExpireController.text,
        commercialInsurance: commercialInsuranceFile.value!,
        commercialInsuranceExpire: commercialInsuranceExpireController.text,
        vehicleRegistration: vehicleRegistrationFile.value!,
        vehicleRegistrationExpire: vehicleRegistrationExpireController.text,
        headshot: headshotFile.value!,
        frontView: frontViewFile.value!,
        rearView: rearViewFile.value!,
        interiorView: interiorViewFile.value!,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Helpers.showCustomSnackBar('Documents submitted!', isError: false);
        Get.offAllNamed(Routes.termPolicy);
      } else {
        final message = response.data is Map
            ? (response.data['message'] ?? 'Something went wrong.')
            : 'Something went wrong.';
        Helpers.showCustomSnackBar(message, isError: true);
      }
    } on DioException catch (e) {
      final message = e.response?.data['message'] ?? 'Something went wrong.';
      Helpers.showCustomSnackBar(message, isError: true);
    } catch (e) {
      Helpers.showCustomSnackBar('Something went wrong.', isError: true);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    licensePlateExpireController.dispose();
    hackLicenseExpireController.dispose();
    localPermitExpireController.dispose();
    commercialInsuranceExpireController.dispose();
    vehicleRegistrationExpireController.dispose();
    super.onClose();
  }
}
