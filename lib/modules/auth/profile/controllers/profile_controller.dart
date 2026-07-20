import 'dart:io';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moeb_26/core/services/user_profile_service.dart';
import 'package:moeb_26/core/utils/helpers.dart';
import 'package:moeb_26/core/utils/media_picker_helper.dart';
import '../../../../data/models/user_profile_model.dart';

class ProfileController extends GetxController {
  final UserProfileService _profileService = Get.find<UserProfileService>();

  // Profile data
  var fullName = "".obs;
  var email = "".obs;
  var phone = "".obs;
  var serviceArea = "".obs;
  var nickName = "".obs;
  var rating = 5.0.obs;
  var ecn = "".obs; // Assuming this is still static or come from another field
  var profilePicture = "".obs;
  var pickedImage = Rxn<File>();

  var isLoading = false.obs;
  var isUpdating = false.obs;
  var userProfile = Rxn<UserProfileModel>();

  // Service Areas
  var serviceAreas = <String>[].obs;
  var isServiceAreasLoading = false.obs;

  // Legal Pages
  var legalPages = <Map<String, dynamic>>[].obs;
  var isLegalsLoading = false.obs;

  // Controllers for Edit Profile Form
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController serviceAreaController;
  late TextEditingController nickNameController;

  @override
  void onInit() {
    super.onInit();
    nameController = TextEditingController();
    emailController = TextEditingController();
    phoneController = TextEditingController();
    serviceAreaController = TextEditingController();
    nickNameController = TextEditingController();
    fetchUserProfile();
    fetchServiceAreas();
    fetchLegalPages();
  }

  Future<void> fetchLegalPages() async {
    isLegalsLoading.value = true;
    try {
      var response = await _profileService.getLegals();
      if (response.statusCode == 200) {
        var dataList = response.data['data'] as List;
        legalPages.value = dataList
            .map(
              (item) => {
                'slug': item['slug'].toString(),
                'title': item['title'].toString(),
              },
            )
            .toList();
      }
    } catch (e) {
      debugPrint("Error fetching legal pages: $e");
    } finally {
      isLegalsLoading.value = false;
    }
  }

  Future<void> fetchServiceAreas() async {
    isServiceAreasLoading.value = true;
    try {
      var response = await _profileService.getServiceAreas();
      if (response.statusCode == 200) {
        var dataList = response.data['data'] as List;
        serviceAreas.value = dataList
            .map((item) => item['areaName'].toString())
            .toList();
      }
    } catch (e) {
      debugPrint("Error fetching service areas: $e");
    } finally {
      isServiceAreasLoading.value = false;
    }
  }

  Future<void> fetchUserProfile() async {
    isLoading.value = true;
    try {
      var response = await _profileService.getUserProfile();
      if (response.statusCode == 200) {
        var data = response.data['data'];
        userProfile.value = UserProfileModel.fromJson(data);

        // Update reactive variables
        fullName.value = userProfile.value?.name ?? "";
        email.value = userProfile.value?.email ?? "";
        phone.value = userProfile.value?.phone ?? "";
        serviceArea.value = userProfile.value?.serviceArea ?? "";
        nickName.value = userProfile.value?.nickname ?? "";
        profilePicture.value = userProfile.value?.profilePicture ?? "";
        rating.value = userProfile.value?.averageRating ?? 0.0;
        ecn.value = userProfile.value?.uid ?? "";

        // Update controllers for the edit form
        nameController.text = fullName.value;
        emailController.text = email.value;
        phoneController.text = phone.value;
        serviceAreaController.text = serviceArea.value;
        nickNameController.text = nickName.value;
      } else {
        Get.snackbar(
          "Error",
          "Failed to load profile",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      debugPrint("Error fetching profile: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> pickImage(BuildContext context) async {
    final hasUploadedPhoto = userProfile.value?.profilePicture != null &&
        userProfile.value!.profilePicture.isNotEmpty;
    if (hasUploadedPhoto) {
      Helpers.showCustomSnackBar("Profile pictures cannot be changed once uploaded.", isError: true);
      return;
    }
    final File? image = await MediaPickerHelper.pickSingleImage(context);

    if (image != null) {
      final compressed = await Helpers.compressImage(image);
      pickedImage.value = compressed;
    }
  }

  Future<void> updateSelectedVehicle(String vehicleId) async {
    isUpdating.value = true;
    try {
      Map<String, dynamic> body = {"selectedVehicle": vehicleId};

      var response = await _profileService.patchProfile(body);
      if (response.statusCode == 200) {
        var data = response.data['data'];
        userProfile.value = UserProfileModel.fromJson(data);

        Helpers.showCustomSnackBar(
          "Vehicle selected successfully",
          isError: false,
        );
      } else {
        Helpers.showCustomSnackBar(
          response.data['message'] ?? "Failed to update selected vehicle",
          isError: true,
        );
      }
    } catch (e) {
      debugPrint("Error updating selected vehicle: $e");
      Helpers.showCustomSnackBar(
        "Something went wrong while selecting vehicle",
        isError: true,
      );
    } finally {
      isUpdating.value = false;
    }
  }

  Future<void> deleteVehicle(String vehicleId) async {
    isUpdating.value = true;
    try {
      var response = await _profileService.deleteVehicle(vehicleId);
      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.back(); // Close dialog first
        Helpers.showCustomSnackBar(
          "Vehicle deleted successfully",
          isError: false,
        );
        fetchUserProfile();
      } else {
        Helpers.showCustomSnackBar(
          response.data['message'] ?? "Failed to delete vehicle",
          isError: true,
        );
      }
    } catch (e) {
      debugPrint("Error deleting vehicle: $e");
      Helpers.showDebugLog("Error deleting vehicle: $e");
    } finally {
      isUpdating.value = false;
    }
  }

  Future<void> saveProfile() async {
    isUpdating.value = true;
    try {
      Map<String, dynamic> body = {
        "name": nameController.text,
        "phone": phoneController.text,
        "nickname": nickNameController.text, // Sent explicitly as "nickname"
      };

      dynamic requestBody;
      if (pickedImage.value != null) {
        requestBody = dio.FormData.fromMap({
          ...body,
          "profilePicture": await dio.MultipartFile.fromFile(
            pickedImage.value!.path,
            filename: pickedImage.value!.path.split('/').last,
          ),
        });
      } else {
        requestBody = body;
      }

      var response = await _profileService.patchProfile(requestBody);
      if (response.statusCode == 200) {
        var data = response.data['data'];
        userProfile.value = UserProfileModel.fromJson(data);

        // Update reactive variables
        fullName.value = userProfile.value?.name ?? "";
        email.value = userProfile.value?.email ?? "";
        phone.value = userProfile.value?.phone ?? "";
        serviceArea.value = userProfile.value?.serviceArea ?? "";
        nickName.value = userProfile.value?.nickname ?? "";
        profilePicture.value = userProfile.value?.profilePicture ?? "";
        rating.value = userProfile.value?.averageRating ?? 0.0;
        ecn.value = userProfile.value?.uid ?? "";

        pickedImage.value = null; // Clear picked image after success
        Get.back(); // Close bottom sheet
        Helpers.showCustomSnackBar(
          "Profile updated successfully",
          isError: false,
        );
      } else {
        Helpers.showCustomSnackBar(
          response.data['message'] ?? "Failed to update profile",
          isError: true,
        );
      }
    } catch (e) {
      debugPrint("Error updating profile: $e");
      Helpers.showCustomSnackBar(
        "Something went wrong while updating profile",
        isError: true,
      );
    } finally {
      isUpdating.value = false;
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    serviceAreaController.dispose();
    nickNameController.dispose();
    super.onClose();
  }

  Future<bool> deleteAccount(String password) async {
    isUpdating.value = true;
    try {
      var response = await _profileService.deleteAccount(password);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        Helpers.showCustomSnackBar(
          response.data['message'] ?? "Failed to delete account",
          isError: true,
        );
        return false;
      }
    } catch (e) {
      debugPrint("Error deleting account: $e");
      Helpers.showCustomSnackBar(
        "Something went wrong while deleting account",
        isError: true,
      );
      return false;
    } finally {
      isUpdating.value = false;
    }
  }
}
