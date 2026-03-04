import 'package:flutter/material.dart';
import 'package:get/get.dart';
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

  var isLoading = false.obs;
  var isUpdating = false.obs;
  var userProfile = Rxn<UserProfileModel>();

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

  Future<void> saveProfile() async {
    isUpdating.value = true;
    try {
      Map<String, dynamic> body = {
        "name": nameController.text,
        "phone": phoneController.text,
        "serviceArea": serviceAreaController.text,
        "nickName": nickNameController.text, // If backend supports it
        // Add other fields as per API if needed, e.g., "home", "experience", "company"
      };

      var response = await _profileService.patchProfile(body);
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

        Get.back(); // Close bottom sheet
        Get.snackbar(
          "Success",
          "Profile updated successfully",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          "Error",
          response.data['message'] ?? "Failed to update profile",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      debugPrint("Error updating profile: $e");
      Get.snackbar(
        "Error",
        "Something went wrong while updating profile",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
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
