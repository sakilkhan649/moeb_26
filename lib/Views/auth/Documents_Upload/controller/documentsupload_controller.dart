import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';

class DocumentsUploadController extends GetxController {
  final ImagePicker _imagePicker = ImagePicker();

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
              primary: Color(0xFF14F195), // Selection color
              onPrimary: Colors.black, // Text on primary
              surface: Color(0xFF1E2939), // Background color
              onSurface: Colors.white, // Text color
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

  // ========== Document files (License Plate, Hack License, etc.) ==========
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

  // ========== Validation error flag ==========
  final RxBool showErrors = false.obs;

  // ========== Pick from Camera ==========
  Future<void> pickFromCamera(Rx<File?> target) async {
    final XFile? image = await _imagePicker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );
    if (image != null) {
      target.value = File(image.path);
    }
  }

  // ========== Pick from File (Gallery / File Manager) ==========
  Future<void> pickFromFile(Rx<File?> target) async {
    final FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
    );
    if (result != null && result.files.single.path != null) {
      target.value = File(result.files.single.path!);
    }
  }

  // ========== Get file name for display ==========
  String getFileName(Rx<File?> file) {
    if (file.value == null) return '';
    return file.value!.path.split(Platform.pathSeparator).last;
  }

  // ========== Validate all required documents ==========
  bool validateDocuments() {
    return licensePlateFile.value != null &&
        hackLicenseFile.value != null &&
        commercialInsuranceFile.value != null &&
        vehicleRegistrationFile.value != null &&
        headshotFile.value != null;
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
