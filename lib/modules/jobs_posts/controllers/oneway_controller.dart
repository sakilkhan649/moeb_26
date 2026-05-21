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
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFF364153), // Selected date circle color
              onPrimary: Colors.white, // Selected date text color
              surface: Color(0xFF1E1E1E), // Slightly lighter than pure black
              onSurface: Colors.white, // Text color on the picker
            ),
            dialogBackgroundColor: const Color(0xFF1E1E1E),
            dialogTheme: DialogThemeData(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: Color(0xFF404040), width: 1),
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedDate.value) {
      selectedDate.value = picked;
    }
  }

  Future<void> chooseTime(BuildContext context) async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime.value ?? TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFF364153), // Selection hand and selected circle
              onPrimary: Colors.white,
              surface: Color(0xFF1E1E1E), // Lighter background
              onSurface: Colors.white, // Text color
            ),
            dialogBackgroundColor: const Color(0xFF1E1E1E),
            dialogTheme: DialogThemeData(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: Color(0xFF404040), width: 1),
              ),
            ),
          ),
          child: MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
            child: child!,
          ),
        );
      },
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
