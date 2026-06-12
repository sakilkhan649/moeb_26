import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:moeb_26/core/utils/helpers.dart';
import 'package:moeb_26/modules/auth/profile/controllers/profile_controller.dart';
import 'package:moeb_26/core/services/user_profile_service.dart';
import 'package:moeb_26/core/widgets/ImagePreviewPopup.dart';

class VehicleActionController extends GetxController {
  final UserProfileService _profileService = Get.find<UserProfileService>();
  final ImagePicker _imagePicker = ImagePicker();

  // Field controllers
  final makeController = TextEditingController();
  final modelController = TextEditingController();
  final yearController = TextEditingController();
  final colorInsideController = TextEditingController();
  final colorOutsideController = TextEditingController();
  final licensePlateController = TextEditingController();
  final commercialInsuranceExpireController = TextEditingController();
  final vehicleRegistrationExpireController = TextEditingController();

  var selectedVehicleType = "".obs;
  var commercialInsuranceFile = Rx<File?>(null);
  var vehicleRegistrationFile = Rx<File?>(null);
  var frontViewFile = Rx<File?>(null);
  var rearViewFile = Rx<File?>(null);
  var interiorViewFile = Rx<File?>(null);

  // Existing image URLs from server (for eye-preview in edit mode)
  var commercialInsuranceUrl = RxnString();
  var vehicleRegistrationUrl = RxnString();
  var frontViewUrl = RxnString();
  var rearViewUrl = RxnString();
  var interiorViewUrl = RxnString();

  var isLoading = false.obs;
  var isEditMode = false.obs;
  String? editVehicleId;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args != null && args['isEdit'] == true && args['vehicle'] != null) {
      isEditMode.value = true;
      final v = args['vehicle'];
      editVehicleId = v.id;

      selectedVehicleType.value = v.carType ?? "";
      makeController.text = v.make ?? "";
      modelController.text = v.model ?? "";
      yearController.text = (v.year ?? "").toString();
      colorInsideController.text = v.colorInside ?? "";
      colorOutsideController.text = v.colorOutside ?? "";
      licensePlateController.text = v.licensePlate ?? "";
      if (v.commercialInsuranceExpiryDate != null &&
          v.commercialInsuranceExpiryDate!.isNotEmpty) {
        try {
          commercialInsuranceExpireController.text = DateFormat(
            'yyyy-MM-dd',
          ).format(DateTime.parse(v.commercialInsuranceExpiryDate!));
        } catch (_) {
          commercialInsuranceExpireController.text =
              v.commercialInsuranceExpiryDate!;
        }
      }

      if (v.vehicleRegistrationExpiryDate != null &&
          v.vehicleRegistrationExpiryDate!.isNotEmpty) {
        try {
          vehicleRegistrationExpireController.text = DateFormat(
            'yyyy-MM-dd',
          ).format(DateTime.parse(v.vehicleRegistrationExpiryDate!));
        } catch (_) {
          vehicleRegistrationExpireController.text =
              v.vehicleRegistrationExpiryDate!;
        }
      }

      // Load existing image URLs for preview
      commercialInsuranceUrl.value = v.commercialInsuranceImage;
      vehicleRegistrationUrl.value = v.vehicleRegistrationImage;
      frontViewUrl.value = v.vehiclePhotoFront;
      rearViewUrl.value = v.vehiclePhotoRear;
      interiorViewUrl.value = v.vehiclePhotoInterior;
    }
  }

  /// Shows the existing server image or the newly picked local file in a dialog.
  void previewImage(
    BuildContext context,
    Rx<File?> fileRx,
    RxnString urlRx, {
    String title = "Image Preview",
  }) {
    final localFile = fileRx.value;
    final serverUrl = urlRx.value;

    if (localFile == null && (serverUrl == null || serverUrl.isEmpty)) {
      Helpers.showCustomSnackBar(
        'No image available to preview.',
        isError: true,
      );
      return;
    }

    Get.dialog(
      ImagePreviewPopup(file: localFile, imageUrl: serverUrl, title: title),
    );
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
          ), dialogTheme: DialogThemeData(backgroundColor: const Color(0xFF1E2939)),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      controller.text = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  bool _isPicking = false;

  Future<void> pickFromCamera(Rx<File?> target) async {
    if (_isPicking) return;
    _isPicking = true;
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );
      if (image != null) {
        final file = File(image.path);
        final compressed = await Helpers.compressImage(file);
        final fileSize = await compressed.length();
        if (fileSize > 1024 * 1024) {
          Helpers.showCustomSnackBar(
            'Maximum file size allowed is 1MB',
            isError: true,
          );
          return;
        }
        target.value = compressed;
      }
    } catch (e) {
      Helpers.error('Error picking from camera: $e');
      Helpers.showCustomSnackBar(
        'Could not open camera. Please check app permissions in settings.',
        isError: true,
      );
    } finally {
      _isPicking = false;
    }
  }

  Future<void> pickFromFile(Rx<File?> target) async {
    if (_isPicking) return;
    _isPicking = true;
    try {
      final FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
      );
      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);
        final path = file.path.toLowerCase();
        final isImage = path.endsWith('.jpg') || path.endsWith('.jpeg') || path.endsWith('.png');

        if (isImage) {
          final compressed = await Helpers.compressImage(file);
          final fileSize = await compressed.length();
          if (fileSize > 1024 * 1024) {
            Helpers.showCustomSnackBar(
              'Maximum file size allowed is 1MB',
              isError: true,
            );
            return;
          }
          target.value = compressed;
        } else {
          final fileSize = await file.length();
          if (fileSize > 1024 * 1024) {
            Helpers.showCustomSnackBar(
              'Maximum file size allowed is 1MB',
              isError: true,
            );
            return;
          }
          target.value = file;
        }
      }
    } catch (e) {
      Helpers.error('Error picking from file: $e');
    } finally {
      _isPicking = false;
    }
  }

  String getFileName(Rx<File?> file) {
    if (file.value == null) return '';
    return file.value!.path.split(Platform.pathSeparator).last;
  }

  Future<void> submitVehicle() async {
    isLoading.value = true;
    try {
      final profileCtrl = Get.find<ProfileController>();
      final formData = dio.FormData();

      // Based on Postman screenshot: vehicles is a JSON string of an array
      Map<String, dynamic> vehicleData = {
        "carType": selectedVehicleType.value,
        "make": makeController.text,
        "model": modelController.text,
        "year": int.tryParse(yearController.text) ?? 2024,
        "colorInside": colorInsideController.text,
        "colorOutside": colorOutsideController.text,
        "licensePlate": licensePlateController.text,
        "vehicleRegistrationExpiryDate":
            vehicleRegistrationExpireController.text,
        "commercialInsuranceExpiryDate":
            commercialInsuranceExpireController.text,
      };

      if (isEditMode.value) {
        // If editing, we include the id so the backend knows which one to replace
        vehicleData["id"] = editVehicleId;
      }

      // Send as a list of one item as per screenshot
      formData.fields.add(MapEntry("vehicles", jsonEncode([vehicleData])));

      // Files - matching Postman exactly
      if (vehicleRegistrationFile.value != null) {
        formData.files.add(
          MapEntry(
            'vehicleRegistrationImage',
            await dio.MultipartFile.fromFile(
              vehicleRegistrationFile.value!.path,
            ),
          ),
        );
      }
      if (commercialInsuranceFile.value != null) {
        formData.files.add(
          MapEntry(
            'commercialInsuranceImage',
            await dio.MultipartFile.fromFile(
              commercialInsuranceFile.value!.path,
            ),
          ),
        );
      }
      if (frontViewFile.value != null) {
        formData.files.add(
          MapEntry(
            'vehiclePhotoFront',
            await dio.MultipartFile.fromFile(frontViewFile.value!.path),
          ),
        );
      }
      if (rearViewFile.value != null) {
        formData.files.add(
          MapEntry(
            'vehiclePhotoRear',
            await dio.MultipartFile.fromFile(rearViewFile.value!.path),
          ),
        );
      }
      if (interiorViewFile.value != null) {
        formData.files.add(
          MapEntry(
            'vehiclePhotoInterior',
            await dio.MultipartFile.fromFile(interiorViewFile.value!.path),
          ),
        );
      }

      var response = await _profileService.patchProfile(formData);
      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.back(); // Navigate back first
        Helpers.showCustomSnackBar(
          isEditMode.value
              ? "Vehicle updated successfully"
              : "Vehicle added successfully",
          isError: false,
        );
        profileCtrl.fetchUserProfile();
      } else {
        Helpers.showCustomSnackBar(
          response.data['message'] ?? "Failed to save vehicle",
          isError: true,
        );
      }
    } catch (e) {
      debugPrint("Error submitting vehicle: $e");
      Helpers.showCustomSnackBar("Something went wrong", isError: true);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    makeController.dispose();
    modelController.dispose();
    yearController.dispose();
    colorInsideController.dispose();
    colorOutsideController.dispose();
    licensePlateController.dispose();
    commercialInsuranceExpireController.dispose();
    vehicleRegistrationExpireController.dispose();
    super.onClose();
  }
}
