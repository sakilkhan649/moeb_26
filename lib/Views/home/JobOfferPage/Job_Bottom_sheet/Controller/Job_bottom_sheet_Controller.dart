import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moeb_26/Core/routs.dart';
import 'package:moeb_26/Services/job_service.dart';
import 'package:moeb_26/widgets/Custom_snacbar.dart' as Helpers;

class PostJobController extends GetxController {
  final JobService _jobService = Get.find<JobService>();

  // Job Type
  var jobType = 'One Way'.obs;

  // Selected Vehicle
  var selectedVehicle = ''.obs;

  var isLoading = false.obs;

  void changeJobType(String newType) {
    jobType.value = newType;
  }

  void selectVehicle(String vehicle) {
    selectedVehicle.value = vehicle;
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
        paymentType: paymentType == 'No Collect' ? 'NO COLLECT' : 'COLLECT',
        instruction: instruction,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Helpers.showCustomSnackBar('Job created successfully!', isError: false);

        Get.back(); // bottom sheet বন্ধ করো
        Get.toNamed(Routes.myJobsScreen);
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
        paymentType: paymentType == 'No Collect' ? 'NO COLLECT' : 'COLLECT',
        instruction: instruction,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Helpers.showCustomSnackBar('Job created successfully!', isError: false);
        Get.back();
        Get.toNamed(Routes.myJobsScreen);
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

  @override
  void onClose() {
    super.onClose();
  }
}
