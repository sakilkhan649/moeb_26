import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:moeb_26/Ripositoryes/job_repository.dart';
import 'package:moeb_26/Utils/helpers.dart';

import 'package:moeb_26/Views/home/RidesPage/Controller/Rides_controller.dart';
import '../../../../../Core/routs.dart';

class RideDetailsController extends GetxController {
  final JobRepo _jobRepo = Get.find<JobRepo>();
  
  var isLoading = false.obs;
  var currentRideStatus = "".obs;
  String? _initializedRideId;

  void setInitialStatus(String? rideId, String? status) {
    // Only set if we haven't initialized for THIS ride yet
    if (_initializedRideId != rideId) {
      _initializedRideId = rideId;
      currentRideStatus.value = status ?? "PENDING";
    }
  }

  Future<void> updateStatus(String jobId, String nextStatus, {dynamic rideData}) async {
    try {
      isLoading.value = true;
      final response = await _jobRepo.updateRideStatus(
        jobId: jobId,
        rideStatus: nextStatus,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        currentRideStatus.value = nextStatus;
        
        // Refresh the main rides list so data is fresh when we go back
        try {
          if (Get.isRegistered<RidesController>()) {
            Get.find<RidesController>().refreshCurrentTab();
          }
        } catch (_) {}

        if (nextStatus == "FINISHED") {
          Get.toNamed(Routes.rideCompletedPage, arguments: rideData ?? {"id": jobId});
        } else {
          Helpers.showCustomSnackBar(
            "Ride status updated to $nextStatus",
            isError: false,
          );
        }
      } else {
        Helpers.showCustomSnackBar(
          response.data['message'] ?? "Failed to update status",
          isError: true,
        );
      }
    } on DioException catch (e) {
      Helpers.showCustomSnackBar(
        e.response?.data['message'] ?? "Error updating status",
        isError: true,
      );
    } catch (e) {
      Helpers.showCustomSnackBar("Something went wrong", isError: true);
    } finally {
      isLoading.value = false;
    }
  }
}
