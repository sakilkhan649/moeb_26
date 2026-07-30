import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:moeb_26/config/routes/app_pages.dart';
import 'package:moeb_26/core/utils/helpers.dart';
import 'package:moeb_26/data/repositories/job_repository.dart';
import 'package:moeb_26/modules/rides/controllers/rides_controller.dart';

class MyRideProgressDetailsController extends GetxController {
  final JobRepo _jobRepo = Get.find<JobRepo>();

  var isLoading = false.obs;
  var currentRideStatus = "".obs;
  String? _initializedRideId;

  void setInitialStatus(String? rideId, String? status) {
    if (_initializedRideId != rideId) {
      _initializedRideId = rideId;
      currentRideStatus.value = status ?? "PENDING";
    }
  }

  Future<void> updateStatus(
    String jobId,
    String nextStatus, {
    dynamic rideData,
  }) async {
    // Static frontend state transition for demo/testing
    currentRideStatus.value = nextStatus;

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
