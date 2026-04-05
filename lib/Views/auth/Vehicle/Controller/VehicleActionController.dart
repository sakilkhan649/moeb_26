import 'dart:convert';
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

class VehicleActionController extends GetxController {
  final UserProfileService _profileService = Get.find<UserProfileService>();
  final ImagePicker _imagePicker = ImagePicker();

  // Field controllers
  final makeController = TextEditingController();
  final modelController = TextEditingController();
  final yearController = TextEditingController();
  final colorController = TextEditingController();
  final licensePlateController = TextEditingController();
  final commercialInsuranceExpireController = TextEditingController();
  final vehicleRegistrationExpireController = TextEditingController();

  var selectedVehicleType = "".obs;
  var commercialInsuranceFile = Rx<File?>(null);
  var vehicleRegistrationFile = Rx<File?>(null);
  var frontViewFile = Rx<File?>(null);
  var rearViewFile = Rx<File?>(null);
  var interiorViewFile = Rx<File?>(null);

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
      colorController.text = v.colorInside ?? "";
      licensePlateController.text = v.licensePlate ?? "";
      commercialInsuranceExpireController.text =
          v.commercialInsuranceExpiryDate ?? "";
      vehicleRegistrationExpireController.text =
          v.vehicleRegistrationExpiryDate ?? "";
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
    if (result != null && result.files.single.path != null)
      target.value = File(result.files.single.path!);
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
        "colorInside": colorController.text,
        "colorOutside": colorController.text,
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
        Helpers.showCustomSnackBar(
          isEditMode.value
              ? "Vehicle updated successfully"
              : "Vehicle added successfully",
          isError: false,
        );
        profileCtrl.fetchUserProfile();
        Get.back();
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
    colorController.dispose();
    licensePlateController.dispose();
    commercialInsuranceExpireController.dispose();
    vehicleRegistrationExpireController.dispose();
    super.onClose();
  }
}
