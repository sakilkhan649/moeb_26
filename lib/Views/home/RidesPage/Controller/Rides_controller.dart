import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:moeb_26/Data/models/my_rides_model.dart';
import 'package:moeb_26/Ripositoryes/job_repository.dart';
import 'package:moeb_26/widgets/Custom_snacbar.dart' as Helpers;

class RidesController extends GetxController {
  final JobRepo _jobRepo = Get.find<JobRepo>();
  RxBool isLoadingList = false.obs;

  var selectedTab = 0.obs; // Default to Upcoming

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments is Map && Get.arguments.containsKey('ridesTab')) {
      selectedTab.value = Get.arguments['ridesTab'];
    }
    fetchPendingJobs();
    fetchUpcomingJobs();
    fetchPastJobs();
  }

  RxList<Ride> upcomingRides = <Ride>[].obs;
  RxList<Ride> pastRides = <Ride>[].obs;
  RxList<Ride> pendingRides = <Ride>[].obs;

  Future<void> fetchPendingJobs() async {
    try {
      isLoadingList.value = true;
      final response = await _jobRepo.getPendingJobs();
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data != null && response.data['data'] != null) {
          final jobResponse = MyRidesResponse.fromJson(response.data);
          pendingRides.assignAll(jobResponse.data);
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

  Future<void> fetchUpcomingJobs() async {
    try {
      isLoadingList.value = true;
      final response = await _jobRepo.getUpcomingJobs();
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data != null && response.data['data'] != null) {
          final jobResponse = MyRidesResponse.fromJson(response.data);
          upcomingRides.assignAll(jobResponse.data);
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

  Future<void> fetchPastJobs() async {
    try {
      isLoadingList.value = true;
      final response = await _jobRepo.getPastJobs();
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data != null && response.data['data'] != null) {
          final jobResponse = MyRidesResponse.fromJson(response.data);
          pastRides.assignAll(jobResponse.data);
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

  List<Ride> get currentRides {
    if (selectedTab.value == 0) return upcomingRides;
    if (selectedTab.value == 1) return pastRides;
    return pendingRides;
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
