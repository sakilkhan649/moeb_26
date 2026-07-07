import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:moeb_26/config/routes/app_pages.dart';
import 'package:moeb_26/core/services/job_service.dart';
import 'package:moeb_26/core/utils/helpers.dart';

class FavoriteDriverSelection {
  final String name;
  final String imageUrl;
  final String vehicleName;
  final double rating;
  final bool isTopRated;

  FavoriteDriverSelection({
    required this.name,
    required this.imageUrl,
    required this.vehicleName,
    required this.rating,
    this.isTopRated = false,
  });
}

class PostJobController extends GetxController {
  final JobService _jobService = Get.find<JobService>();

  // Job Type & Vehicle
  var jobType = 'One Way'.obs;
  var selectedVehicle = ''.obs;
  var isLoading = false.obs;

  // Driver Selection State
  var isGlobal = true.obs;
  var selectedDrivers = <String>[].obs;

  final List<FavoriteDriverSelection> favoriteDrivers = [
    FavoriteDriverSelection(
      name: 'Marcus J.',
      imageUrl:
          'https://images.unsplash.com/photo-1560250097-0b93528c311a?w=150',
      vehicleName: 'Mercedes S-Class',
      rating: 4.98,
      isTopRated: true,
    ),
    FavoriteDriverSelection(
      name: 'Elena V.',
      imageUrl:
          'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150',
      vehicleName: 'Audi e-tron GT',
      rating: 4.95,
      isTopRated: false,
    ),
    FavoriteDriverSelection(
      name: 'Julian K.',
      imageUrl:
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150',
      vehicleName: 'Range Rover Vogue',
      rating: 4.92,
      isTopRated: false,
    ),
  ];

  String get driverSelectionText {
    if (isGlobal.value || selectedDrivers.isEmpty) {
      return 'Global';
    } else {
      return 'Preffered Driver';
    }
  }

  void selectGlobal() {
    isGlobal.value = true;
    selectedDrivers.clear();
  }

  void toggleDriverSelection(String name) {
    if (selectedDrivers.contains(name)) {
      selectedDrivers.remove(name);
      if (selectedDrivers.isEmpty) {
        isGlobal.value = true;
      }
    } else {
      selectedDrivers.add(name);
      isGlobal.value = false;
    }
  }

  // Shared Date, Time, and Payment State
  var selectedRole = 'Credit Card on File'.obs;
  var roles = ['Credit Card on File', 'Collect Payment'].obs;

  var selectedDate = Rxn<DateTime>();
  var selectedTime = Rxn<TimeOfDay>();
  var formattedTime = "".obs;
  var isAsap = false.obs;
  var showAsapError = false.obs;

  void changeJobType(String newType) {
    jobType.value = newType;
  }

  void selectVehicle(String vehicle) {
    selectedVehicle.value = vehicle;
  }

  void toggleAsap(bool? value) {
    isAsap.value = value ?? false;
    showAsapError.value = false;
  }

  void pickRole(String role) {
    selectedRole.value = role;
  }

  // Date and Time Pickers
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
            dialogTheme: DialogThemeData(
              backgroundColor: const Color(0xFF1E1E1E),
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
            dialogTheme: DialogThemeData(
              backgroundColor: const Color(0xFF1E1E1E),
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

  // ========== One Way Job Submit ==========
  Future<void> submitOneWayJob({
    required String pickupLocation,
    required String dropoffLocation,
    required String flightNumber,
    DateTime? date,
    TimeOfDay? time,
    bool? asap,
    required String paymentAmount,
    required String paymentType,
    required String? instruction,
  }) async {
    try {
      isLoading.value = true;

      final response = await _jobService.createJob(
        jobType: "ONE WAY",
        pickupLocation: pickupLocation,
        dropoffLocation: dropoffLocation,
        flightNumber: flightNumber,
        date: asap == true ? null : date?.toUtc().toIso8601String(),
        time: asap == true ? null : time?.format(Get.context!),
        asap: asap,
        vehicleType: selectedVehicle.value,
        paymentAmount: double.tryParse(paymentAmount) ?? 0,
        paymentType: paymentType == 'Credit Card on File'
            ? 'NO COLLECT'
            : 'COLLECT',
        instruction: instruction,
        driverSelection: isGlobal.value ? 'Global' : selectedDrivers.join(', '),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Helpers.showCustomSnackBar('Job created successfully!', isError: false);

        Get.back(); // Close bottom sheet
        Get.toNamed(Routes.myJobsView);
      } else {
        final message = response.data is Map
            ? (response.data['message'] ?? 'Something went wrong.')
            : 'Something went wrong.';
        Helpers.showCustomSnackBar(message, isError: true);
      }
    } on DioException catch (e) {
      final message = e.response?.data['message'] ?? 'Something went wrong.';
      Helpers.showCustomSnackBar(message, isError: true);
    } catch (e) {
      Helpers.showCustomSnackBar('Something went wrong.', isError: true);
    } finally {
      isLoading.value = false;
    }
  }

  // ========== By The Hour Job Submit ==========
  Future<void> submitByTheHourJob({
    required String pickupLocation,
    String? dropoffLocation,
    String? duration,
    required DateTime date,
    required TimeOfDay time,
    required String paymentAmount,
    required String paymentType,
    required String? instruction,
  }) async {
    try {
      isLoading.value = true;

      final response = await _jobService.createJob(
        jobType: "BY THE HOUR",
        pickupLocation: pickupLocation,
        dropoffLocation: dropoffLocation,
        duration: duration,
        date: date.toUtc().toIso8601String(),
        time: time.format(Get.context!),
        vehicleType: selectedVehicle.value,
        paymentAmount: double.tryParse(paymentAmount) ?? 0,
        paymentType: paymentType == 'Credit Card on File'
            ? 'NO COLLECT'
            : 'COLLECT',
        instruction: instruction,
        driverSelection: isGlobal.value ? 'Global' : selectedDrivers.join(', '),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Helpers.showCustomSnackBar('Job created successfully!', isError: false);
        Get.back();
        Get.toNamed(Routes.myJobsView);
      } else {
        final message = response.data is Map
            ? (response.data['message'] ?? 'Something went wrong.')
            : 'Something went wrong.';
        Helpers.showCustomSnackBar(message, isError: true);
      }
    } on DioException catch (e) {
      final message = e.response?.data['message'] ?? 'Something went wrong.';
      Helpers.showCustomSnackBar(message, isError: true);
    } catch (e) {
      Helpers.showCustomSnackBar('Something went wrong.', isError: true);
    } finally {
      isLoading.value = false;
    }
  }
}
