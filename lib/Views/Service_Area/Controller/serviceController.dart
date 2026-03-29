import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:moeb_26/Services/user_service.dart';
import '../../../../Services/serviceAreas_service.dart';
import '../Model/ServiceAreaModel.dart';

class ServiceAreaController extends GetxController {
  final ServiceAreasService _serviceAreasService = Get.put(
    ServiceAreasService(),
  );

  RxList<ServiceAreaModel> serviceAreas = <ServiceAreaModel>[].obs;
  var isLoading = false.obs;
  var isMoreLoading = false.obs;
  var currentPage = 1.obs;
  var totalPages = 1.obs;
  var limit = 10;

  final ScrollController scrollController = ScrollController();
  
  // Selected service area name
  var selectedAreaName = "".obs;
  var isUpdating = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Get current user's service area from profile
    final userProfile = Get.find<UserService>().userId;
    _initCurrentServiceArea();
    // Default load (initial fetch)
    fetchServiceAreas();
    scrollController.addListener(_onScroll);
  }

  void _initCurrentServiceArea() {
    final userService = Get.find<UserService>();
    // If the UserService has the profile data, we could pre-select it
    // For now, it will be updated when the user selects one
  }

  void selectServiceArea(String areaName) {
    selectedAreaName.value = areaName;
  }

  Future<void> updateServiceArea() async {
    if (selectedAreaName.value.isEmpty) {
      Get.snackbar("Error", "Please select a service area first");
      return;
    }

    try {
      isUpdating.value = true;
 
      
      final response = await _serviceAreasService.updateServiceArea(
      selectedAreaName.value
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar("Success", "Service area updated successfully");
        // Optionally refresh user profile in UserService
        Get.find<UserService>().fetchUserId();
        Get.back(); // Go back after success
      } else {
        Get.snackbar("Error", "Failed to update service area");
      }
    } catch (e) {
      print("Error updating service area: $e");
      Get.snackbar("Error", "Something went wrong while updating");
    } finally {
      isUpdating.value = false;
    }
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
        !isLoading.value &&
        !isMoreLoading.value &&
        currentPage.value < totalPages.value) {
      loadMoreServiceAreas();
    }
  }

  Future<void> fetchServiceAreas({bool isRefresh = false}) async {
    // If already loading, don't trigger again
    if (isLoading.value || isMoreLoading.value) return;

    if (isRefresh) {
      currentPage.value = 1;
      // serviceAreas.clear(); // Don't clear immediately to avoid flicker, clear after success
    }

    try {
      if (currentPage.value == 1) {
        isLoading.value = true;
      } else {
        isMoreLoading.value = true;
      }

      print("Service Areas Request: Page ${currentPage.value}, Limit $limit");

      final response = await _serviceAreasService.getAllServiceAreas(
        page: currentPage.value,
        limit: limit,
      );

      print("Service Areas API Response Code: ${response.statusCode}");
      // print("Service Areas API Response Data: ${response.data}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        ServiceAreaResponseModel data;

        if (response.data is Map) {
          data = ServiceAreaResponseModel.fromJson(
            Map<String, dynamic>.from(response.data),
          );
        } else if (response.data is List) {
          data = ServiceAreaResponseModel(
            success: true,
            message: '',
            pagination: PaginationModel(
              total: (response.data as List).length,
              limit: limit,
              page: 1,
              totalPage: 1,
            ),
            data: (response.data as List)
                .map(
                  (e) =>
                      ServiceAreaModel.fromJson(Map<String, dynamic>.from(e)),
                )
                .toList(),
          );
        } else {
          print("Service Areas API: Unknown data format: ${response.data}");
          return;
        }

        totalPages.value = data.pagination.totalPage;

        if (currentPage.value == 1) {
          serviceAreas.assignAll(data.data);
          if (serviceAreas.isEmpty) {
            print(
              "Service Areas API: Response successful but data list is empty",
            );
          }
        } else {
          serviceAreas.addAll(data.data);
        }
        print(
          "Service Areas loaded: ${serviceAreas.length} items (Page ${currentPage.value}/${totalPages.value})",
        );
      } else {
        print(
          "Service Areas API Error: ${response.statusCode} - ${response.statusMessage}",
        );
      }
    } catch (e) {
      print("Error fetching service areas: $e");
    } finally {
      isLoading.value = false;
      isMoreLoading.value = false;
    }
  }

  void loadMoreServiceAreas() {
    if (!isLoading.value &&
        !isMoreLoading.value &&
        currentPage.value < totalPages.value) {
      currentPage.value++;
      fetchServiceAreas();
    }
  }

  // Function to toggle the expanded state of a service area
  void toggleExpansion(int index) {
    if (index >= 0 && index < serviceAreas.length) {
      serviceAreas[index].isExpanded = !serviceAreas[index].isExpanded;
      serviceAreas.refresh(); // Notify Rx listeners
    }
  }
}
