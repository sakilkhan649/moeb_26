import 'package:get/get.dart';

class PostJobController extends GetxController {
  // Job Type - One Way or By the hour
  var jobType = 'One Way'.obs;

  // Selected Vehicle
  var selectedVehicle = ''.obs;

  // Payment Method
  var paymentMethod = 'Collect'.obs;

  // Change Job Type
  void changeJobType(String newType) {
    jobType.value = newType;
  }

  // Select Vehicle
  void selectVehicle(String vehicle) {
    selectedVehicle.value = vehicle;
  }

  // Change Payment Method
  void changePaymentMethod(String? method) {
    if (method != null) {
      paymentMethod.value = method;
    }
  }

  @override
  void onClose() {
    super.onClose();
  }
}
