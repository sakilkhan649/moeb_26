import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  // Profile Data
  var fullName = "Sadat".obs;
  var email = "sadatviper@gmail.com".obs;
  var phone = "01744114084".obs;
  var serviceArea = "Brooklyn".obs;
  var nickName = "Omi Khan".obs;
  var rating = 5.0.obs;
  var ecn = "ECN-456985".obs;

  // Controllers for Edit Profile Form
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController serviceAreaController;
  late TextEditingController nickNameController;

  @override
  void onInit() {
    super.onInit();
    nameController = TextEditingController(text: fullName.value);
    emailController = TextEditingController(text: email.value);
    phoneController = TextEditingController(text: phone.value);
    serviceAreaController = TextEditingController(text: serviceArea.value);
    nickNameController = TextEditingController(text: nickName.value);
  }

  void saveProfile() {
    fullName.value = nameController.text;
    email.value = emailController.text;
    phone.value = phoneController.text;
    serviceArea.value = serviceAreaController.text;
    nickName.value = nickNameController.text;
    Get.back();
    Get.snackbar(
      "Success",
      "Profile updated successfully",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
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
