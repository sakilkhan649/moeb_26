import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moeb_26/Core/routs.dart';
import 'package:moeb_26/Services/user_profile_service.dart';
import 'package:moeb_26/Views/auth/Profile/Controller/profile_controller.dart';
import 'package:moeb_26/Views/auth/Signup_Flow/SignupController.dart';
import '../Model/VehicleModel.dart';

class VehicleInformationController extends GetxController {
  final UserProfileService _profileService = Get.find<UserProfileService>();
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

  Future<void> submitVehicles() async {
    isLoading.value = true;
    try {
      final vehicleData = vehicles.map((v) => v.toJson()).toList();

      if (isEditMode.value) {
        // Build the structure required by the PATCH API
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
          // Refresh ProfileController to show updated vehicles
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
        // Existing Signup Logic
        final signupCtrl = Get.find<SignupController>();
        signupCtrl.saveVehicles(vehicleData);
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
