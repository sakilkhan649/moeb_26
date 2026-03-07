import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../Data/my_jobs_model.dart';
import '../../../../../Ripositoryes/job_repository.dart';
import '../../../../../widgets/Custom_snacbar.dart' as Helpers;
import 'My_job_controller.dart';

class EditController extends GetxController {
  final JobRepo _jobRepo = Get.find<JobRepo>();
  
  var selectedRole = 'No Collect'.obs;
  var roles = ['No Collect', 'Collect'].obs;

  var selectedDate = Rxn<DateTime>();
  var selectedTime = Rxn<TimeOfDay>();

  var selectedVehicle = ''.obs;
  var paymentMethod = 'No Collect'.obs;
  
  var isLoading = false.obs;
  JobData? job;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments is JobData) {
      job = Get.arguments;
      initFields();
    }
  }

  String _normalizePaymentType(String? type) {
    if (type == null) return 'No Collect';
    final t = type.toUpperCase();
    if (t == 'COLLECT') return 'Collect';
    if (t == 'NO_COLLECT' || t == 'NO COLLECT' || t == 'NOCOLLECT') return 'No Collect';
    return 'No Collect';
  }

  String _normalizeVehicleType(String? type) {
    if (type == null) return '';
    final t = type.toLowerCase();
    if (t == 'sedan') return 'Sedan';
    if (t == 'suv') return 'SUV';
    if (t == 'sprinter') return 'Sprinter';
    if (t == 'bus') return 'Bus';
    if (t == 'limostretch') return 'LimoStretch';
    if (t == 'sedan/suv') return 'SEDAN/SUV';
    return type; // fallback to original
  }

  void initFields() {
    if (job == null) return;
    
    selectedVehicle.value = _normalizeVehicleType(job!.vehicleType);
    final normalizedPayment = _normalizePaymentType(job!.paymentType);
    paymentMethod.value = normalizedPayment;
    selectedRole.value = normalizedPayment;
    
    if (job!.date != null) {
      try {
        selectedDate.value = DateTime.parse(job!.date!);
      } catch (_) {}
    }
    
    if (job!.time != null) {
      try {
        // Simple parsing for HH:mm format or similar
        final parts = job!.time!.split(':');
        if (parts.length >= 2) {
          int hour = int.parse(parts[0]);
          int minute = int.parse(parts[1].split(' ')[0]);
          if (job!.time!.toLowerCase().contains('pm') && hour < 12) hour += 12;
          if (job!.time!.toLowerCase().contains('am') && hour == 12) hour = 0;
          selectedTime.value = TimeOfDay(hour: hour, minute: minute);
        }
      } catch (_) {}
    }
  }

  // Function to pick the role
  void pickRole(String role) {
    selectedRole.value = role;
    paymentMethod.value = role;
  }

  // Select Vehicle
  void selectVehicle(String vehicle) {
    selectedVehicle.value = vehicle;
  }

  // Change Payment Method
  void changePaymentMethod(String? method) {
    if (method != null) {
      paymentMethod.value = method;
      selectedRole.value = method;
    }
  }

  Future<void> chooseDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate.value ?? DateTime.now(),
      firstDate: DateTime(2020),
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

  Future<void> updateJob({
    required String pickupLocation,
    required double paymentAmount,
    required String instruction,
    required String dropoffLocation,
  }) async {
    if (job == null) return;
    
    try {
      isLoading.value = true;
      
      final dateStr = selectedDate.value != null 
          ? "${selectedDate.value!.year}-${selectedDate.value!.month.toString().padLeft(2, '0')}-${selectedDate.value!.day.toString().padLeft(2, '0')}"
          : job!.date!;
          
      final timeStr = selectedTime.value != null
          ? "${selectedTime.value!.hour.toString().padLeft(2, '0')}:${selectedTime.value!.minute.toString().padLeft(2, '0')}"
          : job!.time!;

      final response = await _jobRepo.updateJob(
        jobId: job!.id!,
        pickupLocation: pickupLocation,
        paymentAmount: paymentAmount,
        instruction: instruction,
        dropoffLocation: dropoffLocation,
        date: dateStr,
        time: timeStr,
        vehicleType: selectedVehicle.value.toUpperCase(), // Normalize for API
        paymentType: paymentMethod.value == 'Collect' ? 'COLLECT' : 'NO_COLLECT', // Normalize for API
        jobType: job!.jobType ?? 'ONE_WAY',
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Helpers.showCustomSnackBar('Job updated successfully.', isError: false);
        
        // Refresh the list in BookingController
        if (Get.isRegistered<BookingController>()) {
          Get.find<BookingController>().fetchJobs();
        }
        
        Get.back();
      } else {
        final message = response.data is Map
            ? (response.data['message'] ?? 'Failed to update job.')
            : 'Failed to update job.';
        Helpers.showCustomSnackBar(message, isError: true);
      }
    } catch (e) {
      print("Error updating job: $e");
      Helpers.showCustomSnackBar('Something went wrong.', isError: true);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    super.onClose();
  }
}
