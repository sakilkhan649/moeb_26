import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:moeb_26/Utils/helpers.dart';
import '../Model/user_profile_model.dart';
import '../../../../Services/user_profile_service.dart';

class ProfileController extends GetxController {
  final UserProfileService _profileService = Get.find<UserProfileService>();

  // Profile Data
  var fullName = "".obs;
  var email = "".obs;
  var phone = "".obs;
  var serviceArea = "".obs;
  var nickName = "".obs;
  var rating = 5.0.obs;
  var ecn = "ECN-456985"
      .obs; // Assuming this is still static or come from another field
  var profilePicture = "".obs;
  var pickedImage = Rxn<File>();

  var isLoading = false.obs;
  var isUpdating = false.obs;
  var userProfile = Rxn<UserProfileModel>();

  // Service Areas
  var serviceAreas = <String>[].obs;
  var isServiceAreasLoading = false.obs;

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
        nickName.value = userProfile.value?.name ?? "";
        profilePicture.value = userProfile.value?.profilePicture ?? "";
        rating.value = userProfile.value?.averageRating ?? 0.0;

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

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      pickedImage.value = File(image.path);
    }
  }

  Future<void> saveProfile() async {
    isUpdating.value = true;
    try {
      Map<String, dynamic> body = {
        "name": nameController.text,
        "phone": phoneController.text,
        "serviceArea": serviceAreaController.text,
        "nickName": nickNameController.text, // If backend supports it
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
        nickName.value = userProfile.value?.name ?? ""; // Local fallback
        profilePicture.value = userProfile.value?.profilePicture ?? "";
        rating.value = userProfile.value?.averageRating ?? 0.0;

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
}
