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

  // RX variables for newly picked local files
  var drivingLicenseFile = Rx<File?>(null);
  var hackLicenseFile = Rx<File?>(null);
  var localPermitFile = Rx<File?>(null);
  var headshotFile = Rx<File?>(null);

  // Existing image URLs from server (for eye-preview)
  var drivingLicenseUrl = RxnString();
  var hackLicenseUrl = RxnString();
  var localPermitUrl = RxnString();
  var headshotUrl = RxnString();

  // Controllers for Expiry Dates
  final drivingLicenseExpireController = TextEditingController();
  final hackLicenseExpireController = TextEditingController();
  final localPermitExpireController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    _loadExistingDocuments();
  }

  /// Fetches existing document URLs and expiry dates from the profile API.
  Future<void> _loadExistingDocuments() async {
    try {
      final response = await _profileService.getUserProfile();
      if (response.statusCode == 200) {
        final data = response.data['data'];
        if (data == null) return;

        // Driving License
        final dl = data['drivingLicense'];
        if (dl != null) {
          drivingLicenseUrl.value = dl['image']?.toString();
          final dlExpiry = dl['expiryDate']?.toString();
          if (dlExpiry != null && dlExpiry.isNotEmpty) {
            try {
              final parsed = DateTime.parse(dlExpiry);
              drivingLicenseExpireController.text =
                  DateFormat('yyyy-MM-dd').format(parsed);
            } catch (_) {
              drivingLicenseExpireController.text = dlExpiry;
            }
          }
        }

        // Hack License
        final hl = data['hackLicense'];
        if (hl != null) {
          hackLicenseUrl.value = hl['image']?.toString();
          final hlExpiry = hl['expiryDate']?.toString();
          if (hlExpiry != null && hlExpiry.isNotEmpty) {
            try {
              final parsed = DateTime.parse(hlExpiry);
              hackLicenseExpireController.text =
                  DateFormat('yyyy-MM-dd').format(parsed);
            } catch (_) {
              hackLicenseExpireController.text = hlExpiry;
            }
          }
        }

        // Local Permit
        final lp = data['localPermit'];
        if (lp != null) {
          localPermitUrl.value = lp['image']?.toString();
          final lpExpiry = lp['expiryDate']?.toString();
          if (lpExpiry != null && lpExpiry.isNotEmpty) {
            try {
              final parsed = DateTime.parse(lpExpiry);
              localPermitExpireController.text =
                  DateFormat('yyyy-MM-dd').format(parsed);
            } catch (_) {
              localPermitExpireController.text = lpExpiry;
            }
          }
        }

        // Headshot
        headshotUrl.value = data['uploadedHeadshot']?.toString();
      }
    } catch (e) {
      debugPrint('Error loading existing documents: $e');
    }
  }

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
      controller.text = DateFormat('yyyy-MM-dd').format(picked);
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

  /// Shows the existing server image or the newly picked local file in a dialog.
  void previewImage(BuildContext context, Rx<File?> fileRx, RxnString urlRx) {
    final localFile = fileRx.value;
    final serverUrl = urlRx.value;

    if (localFile == null && (serverUrl == null || serverUrl.isEmpty)) {
      Helpers.showCustomSnackBar('No image available to preview.', isError: true);
      return;
    }

    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.black,
        insetPadding: EdgeInsets.all(16),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: localFile != null
              ? Image.file(localFile, fit: BoxFit.contain)
              : Image.network(
                  serverUrl!,
                  fit: BoxFit.contain,
                  loadingBuilder: (_, child, progress) =>
                      progress == null
                          ? child
                          : const Center(child: CircularProgressIndicator()),
                  errorBuilder: (_, __, ___) => const Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      'Failed to load image',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  Future<void> submitDocuments() async {
    isLoading.value = true;
    try {
      final formData = dio.FormData();

      if (drivingLicenseExpireController.text.isNotEmpty) {
        formData.fields.add(
          MapEntry(
            'drivingLicenseExpiryDate',
            drivingLicenseExpireController.text,
          ),
        );
      }
      if (hackLicenseExpireController.text.isNotEmpty) {
        formData.fields.add(
          MapEntry(
            'hackLicenseExpiryDate',
            hackLicenseExpireController.text,
          ),
        );
      }
      if (localPermitExpireController.text.isNotEmpty) {
        formData.fields.add(
          MapEntry(
            'localPermitExpiryDate',
            localPermitExpireController.text,
          ),
        );
      }

      if (drivingLicenseFile.value != null) {
        formData.files.add(
          MapEntry(
            'drivingLicenseImage',
            await dio.MultipartFile.fromFile(drivingLicenseFile.value!.path),
          ),
        );
      }
      if (hackLicenseFile.value != null) {
        formData.files.add(
          MapEntry(
            'hackLicenseImage',
            await dio.MultipartFile.fromFile(hackLicenseFile.value!.path),
          ),
        );
      }
      if (localPermitFile.value != null) {
        formData.files.add(
          MapEntry(
            'localPermitImage',
            await dio.MultipartFile.fromFile(localPermitFile.value!.path),
          ),
        );
      }
      if (headshotFile.value != null) {
        formData.files.add(
          MapEntry(
            'uploadedHeadshot',
            await dio.MultipartFile.fromFile(headshotFile.value!.path),
          ),
        );
      }

      if (formData.fields.isEmpty && formData.files.isEmpty) {
        Helpers.showCustomSnackBar(
          'Please select at least one document or date to update.',
          isError: true,
        );
        isLoading.value = false;
        return;
      }

      var response = await _profileService.patchProfile(formData);
      if (response.statusCode == 200 || response.statusCode == 201) {
        Helpers.showCustomSnackBar(
          'Documents updated successfully',
          isError: false,
        );
        try {
          Get.find<ProfileController>().fetchUserProfile();
        } catch (e) {
          debugPrint('Failed to update profile silently');
        }
        Get.back();
      } else {
        Helpers.showCustomSnackBar(
          response.data['message'] ?? 'Failed to update documents',
          isError: true,
        );
      }
    } catch (e) {
      debugPrint('Error submitting documents: $e');
      Helpers.showCustomSnackBar('Something went wrong', isError: true);
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
