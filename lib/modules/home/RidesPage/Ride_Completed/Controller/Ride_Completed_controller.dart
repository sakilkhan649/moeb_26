import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moeb_26/Utils/helpers.dart';

import 'package:moeb_26/Ripositoryes/job_repository.dart';
import 'package:dio/dio.dart' as dio;

class RideCompletedController extends GetxController {
  final JobRepo _jobRepo = Get.find<JobRepo>();
  
  final RxInt rating = 0.obs;
  final RxString feedback = "".obs;
  final TextEditingController feedbackController = TextEditingController();
  final RxBool isLoading = false.obs;

  void updateRating(int value) {
    rating.value = value;
  }

  Future<void> submitReview() async {
    final dynamic ride = Get.arguments;
    final String jobId = ride is Map ? ride['id'] : (ride?.id ?? "");

    if (jobId.isEmpty) {
      Helpers.showCustomSnackBar("Job ID not found", isError: true);
      return;
    }

    if (rating.value == 0) {
      Helpers.showCustomSnackBar("Please select a rating", isError: true);
      return;
    }

    try {
      isLoading.value = true;
      final response = await _jobRepo.submitReview(
        jobId: jobId,
        rating: rating.value,
        comment: feedback.value,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Helpers.showCustomSnackBar("Review submitted successfully", isError: false);
        // Navigate back to HomeScreens with arguments for tab selection
        Get.back();
      } else {
        Helpers.showCustomSnackBar(
          response.data['message'] ?? "Failed to submit review",
          isError: true,
        );
      }
    } on dio.DioException catch (e) {
      Helpers.showCustomSnackBar(
        e.response?.data['message'] ?? "Error submitting review",
        isError: true,
      );
    } catch (e) {
      Helpers.showCustomSnackBar("Something went wrong", isError: true);
    } finally {
      isLoading.value = false;
    }
  }

  void skipReview() {
    Get.back();
  }

  @override
  void onClose() {
    feedbackController.dispose();
    super.onClose();
  }
}
