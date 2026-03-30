import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:moeb_26/Core/routs.dart';
import 'package:moeb_26/Services/user_profile_service.dart';
import 'package:moeb_26/Views/auth/Profile/Controller/profile_controller.dart';
import 'package:moeb_26/Views/auth/Signup_Flow/SignupController.dart';
import '../Model/VehicleModel.dart';

class VehicleInformationController extends GetxController {
  final UserProfileService _profileService = Get.find<UserProfileService>();
  final ImagePicker _imagePicker = ImagePicker();
  final RxList<VehicleModel> vehicles = <VehicleModel>[].obs;
  var isLoading = false.obs;
  var isEditMode = false.obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null && Get.arguments['vehicles'] != null) {
      isEditMode.value = true;
      final List<dynamic> initialVehicles = Get.arguments['vehicles'];
      for (var v in initialVehicles) {
        vehicles.add(VehicleModel.fromVehicle(v));
      }
    } else {
      addVehicle();
    }
  }

  void addVehicle() {
    vehicles.add(VehicleModel());
  }

  void removeVehicle(int index) {
    if (vehicles.length > 1) {
      vehicles[index].dispose();
      vehicles.removeAt(index);
    }
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

  Future<void> submitVehicles() async {
    isLoading.value = true;
    try {
      if (isEditMode.value) {
        final vehicleData = vehicles.map((v) => v.toJson()).toList();
        Map<String, dynamic> body = {"vehicles": vehicleData};

        var response = await _profileService.patchProfile(body);
        if (response.statusCode == 200) {
          Get.back();
          Get.snackbar(
            "Success",
            "Vehicles updated successfully",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
          if (Get.isRegistered<ProfileController>()) {
            Get.find<ProfileController>().fetchUserProfile();
          }
        } else {
          Get.snackbar(
            "Error",
            response.data['message'] ?? "Failed to update vehicles",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } else {
        // Signup Logic - Saving full models to include files
        final signupCtrl = Get.find<SignupController>();
        signupCtrl.saveVehicles(vehicles.toList());
        
        Get.toNamed(Routes.documentsupload);
      }
    } catch (e) {
      debugPrint("Error submitting vehicles: $e");
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    for (var vehicle in vehicles) {
      vehicle.dispose();
    }
    super.onClose();
  }
}
