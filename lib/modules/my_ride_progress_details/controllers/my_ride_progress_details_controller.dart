import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:moeb_26/config/routes/app_pages.dart';
import 'package:moeb_26/core/utils/helpers.dart';
import 'package:moeb_26/data/models/my_rides_model.dart';
import 'package:moeb_26/data/repositories/job_repository.dart';
import 'package:moeb_26/modules/rides/controllers/rides_controller.dart';

class MyRideProgressDetailsController extends GetxController {
  final JobRepo _jobRepo = Get.find<JobRepo>();

  var isLoading = false.obs;
  var currentRideStatus = "".obs;
  final Rx<RideData?> rideDetails = Rx<RideData?>(null);
  String? _initializedRideId;

  void setInitialStatus(String? rideId, String? status) {
    if (_initializedRideId != rideId) {
      _initializedRideId = rideId;
      currentRideStatus.value = status ?? "PENDING";
    }
  }

  Future<void> fetchJobDetails(String jobId) async {
    if (jobId.isEmpty) return;
    try {
      isLoading.value = true;
      final response = await _jobRepo.getJobById(jobId: jobId);
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data != null &&
            response.data is Map<String, dynamic> &&
            response.data['data'] != null &&
            response.data['data'] is Map<String, dynamic>) {
          final fullRide = RideData.fromJson(response.data['data']);
          rideDetails.value = fullRide;
          final status = fullRide.rideStatus ?? fullRide.status ?? "PENDING";
          currentRideStatus.value = status;
        }
      }
    } catch (e) {
      debugPrint("Error fetching ride details from API: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateStatus(
    String jobId,
    String nextStatus, {
    dynamic rideData,
  }) async {
    currentRideStatus.value = nextStatus;

    try {
      await _jobRepo.updateRideStatus(jobId: jobId, rideStatus: nextStatus);
    } catch (e) {
      debugPrint("Error updating ride status on server: $e");
    }

    try {
      if (Get.isRegistered<RidesController>()) {
        Get.find<RidesController>().refreshCurrentTab();
      }
    } catch (_) {}

    if (nextStatus == "FINISHED") {
      Get.toNamed(
        Routes.rideCompletedView,
        arguments: rideData ?? {"id": jobId},
      );
    } else {
      Helpers.showCustomSnackBar(
        "Ride status updated to $nextStatus",
        isError: false,
      );
    }
  }
}
