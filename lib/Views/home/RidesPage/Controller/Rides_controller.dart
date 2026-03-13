import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:moeb_26/Data/models/finish_rides_model.dart';
import 'package:moeb_26/Data/models/my_rides_model.dart';
import 'package:moeb_26/Data/models/upcoming_rides_model.dart';
import 'package:moeb_26/Ripositoryes/job_repository.dart';
import 'package:moeb_26/widgets/Custom_snacbar.dart' as Helpers;

class RidesController extends GetxController {
  final JobRepo _jobRepo = Get.find<JobRepo>();
  RxBool isLoadingList = false.obs;
  RxBool isLoadMore = false.obs;

  var selectedTab = 0.obs; // Default to Upcoming

  // Pagination states
  int upcomingPage = 1;
  int upcomingTotalPage = 1;
  int pastPage = 1;
  int pastTotalPage = 1;
  int pendingPage = 1;
  int pendingTotalPage = 1;

  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments is Map && Get.arguments.containsKey('ridesTab')) {
      selectedTab.value = Get.arguments['ridesTab'];
    }
    fetchPendingJobs();
    fetchUpcomingJobs();
    fetchPastJobs();
    scrollController.addListener(_onScroll);
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  void _onScroll() {
    if (!scrollController.hasClients || scrollController.positions.length != 1) {
      return;
    }
    if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 200 &&
        !isLoadingList.value &&
        !isLoadMore.value) {
      if (selectedTab.value == 0 && upcomingPage < upcomingTotalPage) {
        loadMoreUpcomingJobs();
      } else if (selectedTab.value == 1 && pastPage < pastTotalPage) {
        loadMorePastJobs();
      } else if (selectedTab.value == 2 && pendingPage < pendingTotalPage) {
        loadMorePendingJobs();
      }
    }
  }

  RxList<UpcomingRideData> upcomingRides = <UpcomingRideData>[].obs;
  RxList<FinishRideData> pastRides = <FinishRideData>[].obs;
  RxList<Ride> pendingRides = <Ride>[].obs;

  Future<void> fetchPendingJobs() async {
    try {
      isLoadingList.value = true;
      pendingPage = 1;
      final response = await _jobRepo.getPendingJobs(page: pendingPage);
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data != null && response.data['data'] != null) {
          final jobResponse = MyRidesResponse.fromJson(response.data);
          pendingRides.assignAll(jobResponse.data);
          pendingTotalPage = jobResponse.pagination?.totalPage ?? 1;
        }
      } else {
        final message = response.data is Map
            ? (response.data['message'] ?? 'Failed to fetch pending jobs.')
            : 'Failed to fetch pending jobs.';
        Helpers.showCustomSnackBar(message, isError: true);
      }
    } on DioException catch (e) {
      final message =
          e.response?.data['message'] ?? 'Failed to fetch pending jobs.';
      Helpers.showCustomSnackBar(message, isError: true);
    } catch (e) {
      print("Error fetching pending jobs: $e");
      Helpers.showCustomSnackBar('Something went wrong.', isError: true);
    } finally {
      isLoadingList.value = false;
    }
  }

  Future<void> loadMorePendingJobs() async {
    try {
      isLoadMore.value = true;
      pendingPage++;
      final response = await _jobRepo.getPendingJobs(page: pendingPage);
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data != null && response.data['data'] != null) {
          final jobResponse = MyRidesResponse.fromJson(response.data);
          pendingRides.addAll(jobResponse.data);
        }
      }
    } catch (e) {
      print("Error loading more pending jobs: $e");
      pendingPage--;
    } finally {
      isLoadMore.value = false;
    }
  }

  Future<void> fetchUpcomingJobs() async {
    try {
      isLoadingList.value = true;
      upcomingPage = 1;
      final response = await _jobRepo.getUpcomingJobs(page: upcomingPage);
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data != null && response.data['data'] != null) {
          final jobResponse = UpcomingRidesModel.fromJson(response.data);
          upcomingRides.assignAll(jobResponse.data ?? []);
          upcomingTotalPage = jobResponse.pagination?.totalPage ?? 1;
        }
      } else {
        final message = response.data is Map
            ? (response.data['message'] ?? 'Failed to fetch upcoming jobs.')
            : 'Failed to fetch upcoming jobs.';
        Helpers.showCustomSnackBar(message, isError: true);
      }
    } on DioException catch (e) {
      final message =
          e.response?.data['message'] ?? 'Failed to fetch upcoming jobs.';
      Helpers.showCustomSnackBar(message, isError: true);
    } catch (e) {
      print("Error fetching upcoming jobs: $e");
      Helpers.showCustomSnackBar('Something went wrong.', isError: true);
    } finally {
      isLoadingList.value = false;
    }
  }

  Future<void> loadMoreUpcomingJobs() async {
    try {
      isLoadMore.value = true;
      upcomingPage++;
      final response = await _jobRepo.getUpcomingJobs(page: upcomingPage);
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data != null && response.data['data'] != null) {
          final jobResponse = UpcomingRidesModel.fromJson(response.data);
          upcomingRides.addAll(jobResponse.data ?? []);
        }
      }
    } catch (e) {
      print("Error loading more upcoming jobs: $e");
      upcomingPage--;
    } finally {
      isLoadMore.value = false;
    }
  }

  Future<void> fetchPastJobs() async {
    try {
      isLoadingList.value = true;
      pastPage = 1;
      final response = await _jobRepo.getPastJobs(page: pastPage);
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data != null && response.data['data'] != null) {
          final jobResponse = FinishRidesModel.fromJson(response.data);
          pastRides.assignAll(jobResponse.data ?? []);
          pastTotalPage = jobResponse.pagination?.totalPage ?? 1;
        }
      } else {
        final message = response.data is Map
            ? (response.data['message'] ?? 'Failed to fetch past jobs.')
            : 'Failed to fetch past jobs.';
        Helpers.showCustomSnackBar(message, isError: true);
      }
    } on DioException catch (e) {
      final message =
          e.response?.data['message'] ?? 'Failed to fetch past jobs.';
      Helpers.showCustomSnackBar(message, isError: true);
    } catch (e) {
      print("Error fetching past jobs: $e");
      Helpers.showCustomSnackBar('Something went wrong.', isError: true);
    } finally {
      isLoadingList.value = false;
    }
  }

  Future<void> loadMorePastJobs() async {
    try {
      isLoadMore.value = true;
      pastPage++;
      final response = await _jobRepo.getPastJobs(page: pastPage);
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data != null && response.data['data'] != null) {
          final jobResponse = FinishRidesModel.fromJson(response.data);
          pastRides.addAll(jobResponse.data ?? []);
        }
      }
    } catch (e) {
      print("Error loading more past jobs: $e");
      pastPage--;
    } finally {
      isLoadMore.value = false;
    }
  }



  void changeTab(int index) {
    selectedTab.value = index;
  }
 
   Future<void> refreshCurrentTab() async {
     if (selectedTab.value == 0) {
       await fetchUpcomingJobs();
     } else if (selectedTab.value == 1) {
       await fetchPastJobs();
     } else {
       await fetchPendingJobs();
     }
   }
}
