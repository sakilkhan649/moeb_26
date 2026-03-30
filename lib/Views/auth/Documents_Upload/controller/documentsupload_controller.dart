import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:moeb_26/Core/routs.dart';
import 'package:moeb_26/Views/auth/Signup_Flow/SignupController.dart';
import 'package:moeb_26/widgets/Custom_snacbar.dart' as Helpers;

class DocumentsUploadController extends GetxController {
  final ImagePicker _imagePicker = ImagePicker();

  var isLoading = false.obs;

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
  final Rx<File?> headshotFile = Rx<File?>(null);
  final Rx<File?> profilePictureFile = Rx<File?>(null);

  // ========== Expire date controllers ==========
  final licensePlateExpireController = TextEditingController();
  final hackLicenseExpireController = TextEditingController();
  final localPermitExpireController = TextEditingController();

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
        headshotFile.value != null;
  }

  // ========== Submit Documents ==========
  Future<void> submitDocuments() async {
    try {
      isLoading.value = true;

      // Save all files/dates to SignupController
      final signupCtrl = Get.find<SignupController>();
      signupCtrl.saveDocuments(
        drivingLicense: licensePlateFile.value!,
        drivingLicenseExpiry: licensePlateExpireController.text,
        hackLicense: hackLicenseFile.value!,
        hackLicenseExpiry: hackLicenseExpireController.text,
        localPermit: localPermitFile.value,
        localPermitExpiry: localPermitExpireController.text.isEmpty
            ? null
            : localPermitExpireController.text,
        headshot: headshotFile.value!,
        profilePicture: profilePictureFile.value,
      );

      // Navigate to PrivacyPolicySignUp (no API call here)
      Get.toNamed(Routes.privacyPolicySignUp);
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
    super.onClose();
  }
}
