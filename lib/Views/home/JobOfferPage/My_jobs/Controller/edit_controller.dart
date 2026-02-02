import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditController extends GetxController {
  var selectedRole = 'No Collect'.obs;
  var roles = ['No Collect', 'Collect'].obs;

  var selectedDate = Rxn<DateTime>();
  var selectedTime = Rxn<TimeOfDay>();

  var selectedVehicle = ''.obs;
  var paymentMethod = 'No Collect'.obs;

  // Function to pick the role
  void pickRole(String role) {
    selectedRole.value = role;
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

  Future<void> chooseDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate.value ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != selectedDate.value) {
      selectedDate.value = picked;
    }
  }

  Future<void> chooseTime(BuildContext context) async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime.value ?? TimeOfDay.now(),
    );
    if (picked != null && picked != selectedTime.value) {
      selectedTime.value = picked;
    }
  }

  @override
  void onClose() {
    super.onClose();
  }
}
