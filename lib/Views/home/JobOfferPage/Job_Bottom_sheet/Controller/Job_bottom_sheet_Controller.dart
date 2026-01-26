import 'package:get/get.dart';

// Post Job এর সব data manage করার controller
class PostJobController extends GetxController {
  // Job Type - One Way বা By the hour
  var jobType = 'One Way'.obs;

  // Selected Vehicle Type
  var selectedVehicle = ''.obs;

  // Payment Method - No collect বা Collect
  var paymentMethod = 'Collect'.obs;

  // Text field controllers
  var pickupLocation = ''.obs;
  var dropoffLocation = ''.obs;
  var flightNumber = ''.obs;
  var date = ''.obs;
  var time = ''.obs;
  var payAmount = ''.obs;
  var specialInstructions = ''.obs;

  // Job Type change করার method
  void changeJobType(String type) {
    jobType.value = type;
  }

  // Vehicle select করার method
  void selectVehicle(String vehicle) {
    selectedVehicle.value = vehicle;
  }

  // Payment Method change করার method
  void changePaymentMethod(String? method) {
    if (method != null) {
      paymentMethod.value = method;
    }
  }

  // Form submit করার method
  void submitJob() {
    // Validation check করুন
    if (pickupLocation.isEmpty) {
      Get.snackbar('Error', 'Please enter pickup location');
      return;
    }
    if (dropoffLocation.isEmpty) {
      Get.snackbar('Error', 'Please enter drop-off location');
      return;
    }
    if (selectedVehicle.isEmpty) {
      Get.snackbar('Error', 'Please select a vehicle type');
      return;
    }

    // Success message
    Get.snackbar('Success', 'Job posted successfully!');
    Get.back(); // Bottom sheet close করুন
  }
}