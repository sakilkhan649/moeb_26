import 'dart:io';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:moeb_26/Services/user_profile_service.dart';
import 'package:moeb_26/Views/auth/Profile/Controller/profile_controller.dart';
import 'package:moeb_26/Utils/helpers.dart';

class PersonalDocumentController extends GetxController {
  final UserProfileService _profileService = Get.find<UserProfileService>();
  final ImagePicker _imagePicker = ImagePicker();

  var isLoading = false.obs;

  // RX variables for files
  var drivingLicenseFile = Rx<File?>(null);
  var hackLicenseFile = Rx<File?>(null);
  var localPermitFile = Rx<File?>(null);
  var headshotFile = Rx<File?>(null);

  // Controllers for Expiry Dates
  final drivingLicenseExpireController = TextEditingController();
  final hackLicenseExpireController = TextEditingController();
  final localPermitExpireController = TextEditingController();

  Future<void> selectDate(BuildContext context, TextEditingController controller) async {
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
            surface: const Color(0xFF1E2939),
            onSurface: Colors.white,
          ),
          dialogBackgroundColor: const Color(0xFF1E2939),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      controller.text = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  Future<void> pickFromCamera(Rx<File?> target) async {
    final XFile? image = await _imagePicker.pickImage(source: ImageSource.camera, imageQuality: 80);
    if (image != null) target.value = File(image.path);
  }

  Future<void> pickFromFile(Rx<File?> target) async {
    final FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png']);
    if (result != null && result.files.single.path != null) target.value = File(result.files.single.path!);
  }

  String getFileName(Rx<File?> file) {
    if (file.value == null) return '';
    return file.value!.path.split(Platform.pathSeparator).last;
  }

  Future<void> submitDocuments() async {
    isLoading.value = true;
    try {
      final formData = dio.FormData();

      if (drivingLicenseExpireController.text.isNotEmpty) {
        formData.fields.add(MapEntry('drivingLicenseExpiryDate', drivingLicenseExpireController.text));
      }
      if (hackLicenseExpireController.text.isNotEmpty) {
        formData.fields.add(MapEntry('hackLicenseExpiryDate', hackLicenseExpireController.text));
      }
      if (localPermitExpireController.text.isNotEmpty) {
        formData.fields.add(MapEntry('localPermitExpiryDate', localPermitExpireController.text));
      }

      if (drivingLicenseFile.value != null) {
        formData.files.add(MapEntry('drivingLicenseImage', await dio.MultipartFile.fromFile(drivingLicenseFile.value!.path)));
      }
      if (hackLicenseFile.value != null) {
        formData.files.add(MapEntry('hackLicenseImage', await dio.MultipartFile.fromFile(hackLicenseFile.value!.path)));
      }
      if (localPermitFile.value != null) {
        formData.files.add(MapEntry('localPermitImage', await dio.MultipartFile.fromFile(localPermitFile.value!.path)));
      }
      if (headshotFile.value != null) {
        formData.files.add(MapEntry('uploadedHeadshot', await dio.MultipartFile.fromFile(headshotFile.value!.path)));
      }
      
      // Basic check
      if (formData.fields.isEmpty && formData.files.isEmpty) {
        Helpers.showCustomSnackBar("Please select at least one document or date to update.", isError: true);
        isLoading.value = false;
        return;
      }

      var response = await _profileService.patchProfile(formData);
      if (response.statusCode == 200 || response.statusCode == 201) {
        Helpers.showCustomSnackBar("Documents updated successfully", isError: false);
        try { Get.find<ProfileController>().fetchUserProfile(); } catch (e) {
          debugPrint("Failed to update profile silently");
        }
        Get.back();
      } else {
        Helpers.showCustomSnackBar(response.data['message'] ?? "Failed to update documents", isError: true);
      }
    } catch (e) {
      debugPrint("Error submitting documents: $e");
      Helpers.showCustomSnackBar("Something went wrong", isError: true);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    drivingLicenseExpireController.dispose();
    hackLicenseExpireController.dispose();
    localPermitExpireController.dispose();
    super.onClose();
  }
}
