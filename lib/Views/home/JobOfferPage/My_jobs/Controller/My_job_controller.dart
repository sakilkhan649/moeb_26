import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:moeb_26/Core/routs.dart';
import 'package:moeb_26/Data/models/job_model.dart';
import 'package:moeb_26/Data/my_jobs_model.dart';
import 'package:moeb_26/Ripositoryes/job_repository.dart';
import 'package:moeb_26/Services/job_service.dart';
import 'package:moeb_26/widgets/Custom_snacbar.dart' as Helpers;

class BookingController extends GetxController {
  final JobService _jobService = Get.find<JobService>();
  final JobRepo _jobRepo = Get.find<JobRepo>();

  var isDeleted = false.obs;
  var isJobAcceptanceView = false.obs;

  var isLoadingList = false.obs;
  var isLoadMore = false.obs;
  var page = 1;
  var hasNextPage = true.obs;

  RxList<JobData> myJobsList = <JobData>[].obs;
  RxList<Job> jobOffersList = <Job>[].obs;
  
  // Per-button loading states
  final approveLoading = <String, bool>{}.obs;
  final rejectLoading = <String, bool>{}.obs;
  final viewLoading = <String, bool>{}.obs;

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
          final jobResponse = MyJobsModel.fromJson(response.data);
          myJobsList.assignAll(jobResponse.data!);
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

  Future<void> fetchJobOffers({bool isRefresh = false}) async {
    if (isRefresh) {
      page = 1;
      hasNextPage.value = true;
    }

    if (!hasNextPage.value) return;

    try {
      if (page == 1) {
        isLoadingList.value = true;
      } else {
        isLoadMore.value = true;
      }

      final response = await _jobService.getAllJobOffers(page: page);
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data != null && response.data['data'] != null) {
          final jobResponse = JobResponse.fromJson(response.data);
          final newJobs = jobResponse.data;

          if (page == 1) {
            jobOffersList.assignAll(newJobs);
          } else {
            jobOffersList.addAll(newJobs);
          }

          if (jobResponse.pagination != null) {
            if (page >= jobResponse.pagination!.totalPage) {
              hasNextPage.value = false;
            } else {
              page++;
            }
          } else {
            // Fallback if pagination is null
            if (newJobs.isEmpty || newJobs.length < 10) {
              hasNextPage.value = false;
            } else {
              page++;
            }
          }
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
      isLoadMore.value = false;
    }
  }

  Future<void> loadMoreJobOffers() async {
    if (!isLoadMore.value && hasNextPage.value) {
      await fetchJobOffers();
    }
  }

  void setJobAcceptanceView(bool value) {
    isJobAcceptanceView.value = value;
  }

  Future<void> applyToJob({required String jobId}) async {
    try {
      isLoadingList.value = true;
      final response = await _jobService.applyToJob(jobId: jobId);
      if (response.statusCode == 200 || response.statusCode == 201) {
        // Find the job object before removing it from the list
        final appliedJob = jobOffersList.firstWhere((job) => job.id == jobId);

        // Remove the job from the list
        jobOffersList.removeWhere((job) => job.id == jobId);

        Helpers.showCustomSnackBar('Job applied successfully.', isError: false);
        Get.toNamed(Routes.requestSubmitted, arguments: appliedJob);
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

  Future<void> rejectApplicant({required String jobId}) async {
    try {
      isLoadingList.value = true;
      rejectLoading[jobId] = true;
      final response = await _jobRepo.rejectApplicant(jobId: jobId);
      if (response.statusCode == 200 || response.statusCode == 201) {
        // Refresh the list after rejection
        await fetchJobs();
        
        Helpers.showCustomSnackBar(
          'Job rejected successfully.',
          isError: false,
        );
      } else {
        final message = response.data is Map
            ? (response.data['message'] ?? 'Failed to reject job.')
            : 'Failed to reject job.';
        Helpers.showCustomSnackBar(message, isError: true);
      }
    } on DioException catch (e) {
      final message = e.response?.data['message'] ?? 'Failed to reject job.';
      Helpers.showCustomSnackBar(message, isError: true);
    } catch (e) {
      print("Error rejecting job: $e");
      Helpers.showCustomSnackBar('Something went wrong.', isError: true);
    } finally {
      isLoadingList.value = false;
      rejectLoading[jobId] = false;
    }
  }

  Future<void> approveApplicant({required String jobId}) async {
    try {
      isLoadingList.value = true;
      approveLoading[jobId] = true;
      final response = await _jobRepo.approveApplicant(jobId: jobId);
      if (response.statusCode == 200 || response.statusCode == 201) {
        // Refresh the list after approval
        await fetchJobs();

        Helpers.showCustomSnackBar(
          'Job approved successfully.',
          isError: false,
        );
      } else {
        final message = response.data is Map
            ? (response.data['message'] ?? 'Failed to approve job.')
            : 'Failed to approve job.';
        Helpers.showCustomSnackBar(message, isError: true);
      }
    } on DioException catch (e) {
      final message = e.response?.data['message'] ?? 'Failed to approve job.';
      Helpers.showCustomSnackBar(message, isError: true);
    } catch (e) {
      print("Error approving job: $e");
      Helpers.showCustomSnackBar('Something went wrong.', isError: true);
    } finally {
      isLoadingList.value = false;
      approveLoading[jobId] = false;
    }
  }

  Future<void> deleteJob({required String jobId}) async {
    try {
      isLoadingList.value = true;
      final response = await _jobRepo.deleteJob(jobId: jobId);
      if (response.statusCode == 200 || response.statusCode == 201) {
        // Remove the job from both lists to update UI immediately
        myJobsList.removeWhere((job) => job.id == jobId);
        Helpers.showCustomSnackBar('Job deleted successfully.', isError: false);
      } else {
        final message = response.data is Map
            ? (response.data['message'] ?? 'Failed to delete job.')
            : 'Failed to delete job.';
        Helpers.showCustomSnackBar(message, isError: true);
      }
    } on DioException catch (e) {
      final message = e.response?.data['message'] ?? 'Failed to delete job.';
      Helpers.showCustomSnackBar(message, isError: true);
    } catch (e) {
      print("Error deleting job: $e");
    } finally {
      isLoadingList.value = false;
    }
  }

  // Future<void> updateJob({
  //   required String jobId,
  //   required String pickupLocation,
  //   required double paymentAmount,
  //   required String instruction,
  //   required String dropoffLocation,
  //   required String date,
  //   required String time,
  //   required String vehicleType,
  //   required String paymentType,
  //   required String jobType,
  // }) async {
  //   try {
  //     isLoadingList.value = true;
  //     final response = await _jobRepo.updateJob(
  //       jobId: jobId,
  //       pickupLocation: pickupLocation,
  //       paymentAmount: paymentAmount,
  //       instruction: instruction,
  //       dropoffLocation: dropoffLocation,
  //       date: date,
  //       time: time,
  //       vehicleType: vehicleType,
  //       paymentType: paymentType,
  //       jobType: jobType,
  //     );
  //     if (response.statusCode == 200 || response.statusCode == 201) {
  //       // Update the job in the list
  //       final index = myJobsList.indexWhere((job) => job.id == jobId);
  //       if (index != -1) {
  //         myJobsList[index] = response.data;
  //       }
  //       Helpers.showCustomSnackBar('Job updated successfully.', isError: false);
  //     } else {
  //       final message = response.data is Map
  //           ? (response.data['message'] ?? 'Failed to update job.')
  //           : 'Failed to update job.';
  //       Helpers.showCustomSnackBar(message, isError: true);
  //     }
  //   } on DioException catch (e) {
  //     final message = e.response?.data['message'] ?? 'Failed to update job.';
  //     Helpers.showCustomSnackBar(message, isError: true);
  //   } catch (e) {
  //     print("Error updating job: $e");
  //     Helpers.showCustomSnackBar('Something went wrong.', isError: true);
  //   } finally {
  //     isLoadingList.value = false;
  //   }
  // }


Future<void> cancelJobOffer({required String jobId}) async {
    try {
      isLoadingList.value = true;
      final response = await _jobRepo.cancelJobOffer(jobId: jobId);
      if (response.statusCode == 200 || response.statusCode == 201) {
        // Refresh the list after cancellation
        await fetchJobs();
        Helpers.showCustomSnackBar('Job cancelled successfully.', isError: false);
      } else {
        final message = response.data is Map
            ? (response.data['message'] ?? 'Failed to cancel job.')
            : 'Failed to cancel job.';
        Helpers.showCustomSnackBar(message, isError: true);
      }
    } on DioException catch (e) {
      final message = e.response?.data['message'] ?? 'Failed to cancel job.';
      Helpers.showCustomSnackBar(message, isError: true);
    } catch (e) {
      print("Error canceling job: $e");
      Helpers.showCustomSnackBar('Something went wrong.', isError: true);
    } finally {
      isLoadingList.value = false;
    }
}
}
