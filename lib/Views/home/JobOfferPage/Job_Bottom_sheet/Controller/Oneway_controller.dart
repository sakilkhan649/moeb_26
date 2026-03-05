import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class OnewayController extends GetxController {
  var selectedRole = 'No Collect'.obs;
  var roles = ['No Collect', 'Collect'].obs;

  var selectedDate = Rxn<DateTime>();
  var selectedTime = Rxn<TimeOfDay>();
  var formattedTime = "".obs;
  var isAsap = false.obs;
  var showAsapError = false.obs;

  void toggleAsap(bool? value) {
    isAsap.value = value ?? false;
    showAsapError.value = false;
  }

  // Function to pick the role
  void pickRole(String role) {
    selectedRole.value = role;
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

      // Format to 12-hour AM/PM
      final now = DateTime.now();
      final dateTime = DateTime(
        now.year,
        now.month,
        now.day,
        picked.hour,
        picked.minute,
      );
      formattedTime.value = DateFormat('hh:mm a').format(dateTime);
    }
  }
}
