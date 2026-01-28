import 'package:get/get.dart';

class EditController extends GetxController {

  // Selected Vehicle
  var selectedVehicle = ''.obs;

  // Payment Method
  var paymentMethod = 'Collect'.obs;

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
