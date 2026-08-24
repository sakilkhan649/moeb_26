import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:moeb_26/config/routes/app_pages.dart';
import 'package:moeb_26/core/services/job_service.dart';
import 'package:moeb_26/core/utils/helpers.dart';
import 'package:moeb_26/data/models/job_offer_model.dart';

class JobOfferController extends GetxController {
  late final JobService _jobService;

  final RxList<JobOfferModel> jobOffers = <JobOfferModel>[].obs;
  final RxMap<String, List<JobOfferModel>> groupedJobOffers =
      <String, List<JobOfferModel>>{}.obs;

  final RxBool isLoading = false.obs;
  final RxBool isApplying = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _jobService = Get.isRegistered<JobService>()
        ? Get.find<JobService>()
        : Get.put(JobService());
    fetchJobOffers();
  }

  Future<void> fetchJobOffers({bool isRefresh = false}) async {
    if (!isRefresh) {
      isLoading.value = true;
    }
    errorMessage.value = '';

    try {
      final response = await _jobService.getAllJobOffers();
      if (response.statusCode == 200 || response.statusCode == 201) {
        final dynamic rawData = response.data?['data'];
        final List<dynamic> list = (rawData is List) ? rawData : [];

        final items = list
            .map((item) {
              try {
                return JobOfferModel.fromJson(item as Map<String, dynamic>);
              } catch (e) {
                debugPrint("Error parsing JobOffer item: $e");
                return null;
              }
            })
            .whereType<JobOfferModel>()
            .toList();

        jobOffers.assignAll(items);
        _groupOffersByDate(items);
      } else {
        errorMessage.value =
            response.data?['message']?.toString() ?? 'Failed to load offers.';
      }
    } on DioException catch (e) {
      errorMessage.value =
          e.response?.data?['message']?.toString() ?? 'Failed to load offers.';
      debugPrint("Dio error fetching job offers: $e");
    } catch (e) {
      errorMessage.value = 'Something went wrong while loading offers.';
      debugPrint("Error fetching job offers: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void _groupOffersByDate(List<JobOfferModel> items) {
    final Map<String, List<JobOfferModel>> groups = {};

    for (final job in items) {
      String header;
      if (job.asap) {
        final created = job.createdAt ?? DateTime.now();
        header = "Today, ${DateFormat('MMM dd').format(created)}";
      } else if (job.date != null) {
        header = DateFormat('EEE, MMM dd').format(job.date!);
      } else if (job.createdAt != null) {
        header = "Today, ${DateFormat('MMM dd').format(job.createdAt!)}";
      } else {
        header = 'Available Offers';
      }

      if (!groups.containsKey(header)) {
        groups[header] = [];
      }
      groups[header]!.add(job);
    }

    groupedJobOffers.assignAll(groups);
  }

  Future<void> applyToJob(JobOfferModel job) async {
    try {
      isApplying.value = true;

      final response = await _jobService.applyToJob(jobId: job.id);

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.back(); // Close bottom sheet if open

        Helpers.showCustomSnackBar(
          response.data?['message']?.toString() ??
              'Applied to job successfully!',
          isError: false,
        );

        // Remove from list or refresh feed
        jobOffers.removeWhere((item) => item.id == job.id);
        _groupOffersByDate(jobOffers);

        // Navigate to Application Status / Review screen
        Get.toNamed(
          Routes.requestSubmittedView,
          arguments: job.toJson(),
        );
      } else {
        final message = response.data?['message']?.toString() ??
            'Failed to apply for job.';
        Helpers.showCustomSnackBar(message, isError: true);
      }
    } on DioException catch (e) {
      final message =
          e.response?.data?['message']?.toString() ?? 'Failed to apply.';
      Helpers.showCustomSnackBar(message, isError: true);
    } catch (e) {
      Helpers.showCustomSnackBar('Something went wrong.', isError: true);
      debugPrint("Error applying to job: $e");
    } finally {
      isApplying.value = false;
    }
  }
}
