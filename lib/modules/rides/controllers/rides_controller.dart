import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moeb_26/core/utils/helpers.dart';
import 'package:moeb_26/data/models/my_rides_model.dart';
import 'package:moeb_26/data/repositories/job_repository.dart';

class RidesController extends GetxController {
  final JobRepo _jobRepo = Get.find<JobRepo>();
  RxBool isLoadingList = false.obs;
  RxBool isLoadMore = false.obs;

  var selectedTab = 0.obs; // 0 = Upcoming, 1 = Past

  // Cursor pagination states
  String? upcomingNextCursor;
  bool upcomingHasMore = false;

  String? pastNextCursor;
  bool pastHasMore = false;

  final ScrollController scrollController = ScrollController();

  RxList<RideData> upcomingRides = <RideData>[].obs;
  RxList<RideData> pastRides = <RideData>[].obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments is Map && Get.arguments.containsKey('ridesTab')) {
      selectedTab.value = Get.arguments['ridesTab'];
    }
    if (selectedTab.value == 0) {
      fetchUpcomingJobs();
    } else if (selectedTab.value == 1) {
      fetchPastJobs();
    }
    scrollController.addListener(_onScroll);
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  void _onScroll() {
    if (!scrollController.hasClients ||
        scrollController.positions.length != 1) {
      return;
    }
    if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 200 &&
        !isLoadingList.value &&
        !isLoadMore.value) {
      if (selectedTab.value == 0) {
        if (upcomingHasMore && upcomingNextCursor != null) {
          loadMoreUpcomingJobs();
        }
      } else if (selectedTab.value == 1) {
        if (pastHasMore && pastNextCursor != null) {
          loadMorePastJobs();
        }
      }
    }
  }

  Future<void> fetchUpcomingJobs() async {
    try {
      isLoadingList.value = true;
      upcomingNextCursor = null;
      final response = await _jobRepo.getUpcomingJobs(cursor: null);
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data != null && response.data is Map<String, dynamic>) {
          final ridesResponse = MyRidesModel.fromJson(response.data);
          upcomingRides.assignAll(ridesResponse.data);
          upcomingNextCursor = ridesResponse.cursor?.nextCursor;
          upcomingHasMore = ridesResponse.cursor?.hasMore ?? false;
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
    if (!upcomingHasMore || upcomingNextCursor == null || isLoadMore.value) {
      return;
    }

    try {
      isLoadMore.value = true;
      final response = await _jobRepo.getUpcomingJobs(cursor: upcomingNextCursor);
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data != null && response.data is Map<String, dynamic>) {
          final ridesResponse = MyRidesModel.fromJson(response.data);
          upcomingRides.addAll(ridesResponse.data);
          upcomingNextCursor = ridesResponse.cursor?.nextCursor;
          upcomingHasMore = ridesResponse.cursor?.hasMore ?? false;
        }
      }
    } catch (e) {
      print("Error loading more upcoming jobs: $e");
    } finally {
      isLoadMore.value = false;
    }
  }

  Future<void> fetchPastJobs() async {
    try {
      isLoadingList.value = true;
      pastNextCursor = null;
      final response = await _jobRepo.getPastJobs(cursor: null);
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data != null && response.data is Map<String, dynamic>) {
          final ridesResponse = MyRidesModel.fromJson(response.data);
          pastRides.assignAll(ridesResponse.data);
          pastNextCursor = ridesResponse.cursor?.nextCursor;
          pastHasMore = ridesResponse.cursor?.hasMore ?? false;
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
    if (!pastHasMore || pastNextCursor == null || isLoadMore.value) {
      return;
    }

    try {
      isLoadMore.value = true;
      final response = await _jobRepo.getPastJobs(cursor: pastNextCursor);
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data != null && response.data is Map<String, dynamic>) {
          final ridesResponse = MyRidesModel.fromJson(response.data);
          pastRides.addAll(ridesResponse.data);
          pastNextCursor = ridesResponse.cursor?.nextCursor;
          pastHasMore = ridesResponse.cursor?.hasMore ?? false;
        }
      }
    } catch (e) {
      print("Error loading more past jobs: $e");
    } finally {
      isLoadMore.value = false;
    }
  }

  void changeTab(int index) {
    selectedTab.value = index;
    if (index == 0) {
      fetchUpcomingJobs();
    } else if (index == 1) {
      fetchPastJobs();
    }
  }

  Future<void> refreshCurrentTab() async {
    if (selectedTab.value == 0) {
      await fetchUpcomingJobs();
    } else if (selectedTab.value == 1) {
      await fetchPastJobs();
    }
  }
}
