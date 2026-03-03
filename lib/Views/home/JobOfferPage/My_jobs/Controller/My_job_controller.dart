import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:moeb_26/Core/routs.dart';
import 'package:moeb_26/Data/models/job_model.dart';
import 'package:moeb_26/Services/job_service.dart';
import 'package:moeb_26/widgets/Custom_snacbar.dart' as Helpers;

class BookingController extends GetxController {
  final JobService _jobService = Get.find<JobService>();

  var isDeleted = false.obs;
  var isJobAcceptanceView = false.obs;

  var isLoadingList = false.obs;

  RxList<Job> jobsList = <Job>[].obs;
  RxList<Job> jobOffersList = <Job>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchJobs();
    fetchJobOffers();
  }

  Future<void> fetchJobs() async {
    try {
      isLoadingList.value = true;
      final response = await _jobService.getJobs();
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data != null && response.data['data'] != null) {
          final jobResponse = JobResponse.fromJson(response.data);
          jobsList.assignAll(jobResponse.data);
        }
      } else {
        final message = response.data is Map
            ? (response.data['message'] ?? 'Failed to fetch jobs.')
            : 'Failed to fetch jobs.';
        Helpers.showCustomSnackBar(message, isError: true);
      }
    } on DioException catch (e) {
      final message = e.response?.data['message'] ?? 'Failed to fetch jobs.';
      Helpers.showCustomSnackBar(message, isError: true);
    } catch (e) {
      print("Error fetching jobs: $e");
      Helpers.showCustomSnackBar('Something went wrong.', isError: true);
    } finally {
      isLoadingList.value = false;
    }
  }

  Future<void> fetchJobOffers() async {
    try {
      isLoadingList.value = true;
      final response = await _jobService.getAllJobOffers();
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data != null && response.data['data'] != null) {
          final jobResponse = JobResponse.fromJson(response.data);
          jobOffersList.assignAll(jobResponse.data);
        }
      } else {
        final message = response.data is Map
            ? (response.data['message'] ?? 'Failed to fetch job offers.')
            : 'Failed to fetch job offers.';
        Helpers.showCustomSnackBar(message, isError: true);
      }
    } on DioException catch (e) {
      final message =
          e.response?.data['message'] ?? 'Failed to fetch job offers.';
      Helpers.showCustomSnackBar(message, isError: true);
    } catch (e) {
      print("Error fetching job offers: $e");
      Helpers.showCustomSnackBar('Something went wrong.', isError: true);
    } finally {
      isLoadingList.value = false;
    }
  }

  void deleteItem() {
    isDeleted.value = true;
  }

  void setJobAcceptanceView(bool value) {
    isJobAcceptanceView.value = value;
  }

  Future<void> applyToJob({required String jobId}) async {
    try {
      isLoadingList.value = true;
      final response = await _jobService.applyToJob(jobId: jobId);
      if (response.statusCode == 200 || response.statusCode == 201) {
        Helpers.showCustomSnackBar('Job applied successfully.', isError: false);
        Get.toNamed(Routes.requestSubmitted);
      } else {
        final message = response.data is Map
            ? (response.data['message'] ?? 'Failed to apply for job.')
            : 'Failed to apply for job.';
        Helpers.showCustomSnackBar(message, isError: true);
      }
    } on DioException catch (e) {
      final message = e.response?.data['message'] ?? 'Failed to apply for job.';
      Helpers.showCustomSnackBar(message, isError: true);
    } catch (e) {
      print("Error applying for job: $e");
      Helpers.showCustomSnackBar('Something went wrong.', isError: true);
    } finally {
      isLoadingList.value = false;
    }
  }
}
