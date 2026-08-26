import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:moeb_26/core/services/serviceAreas_service.dart';
import 'package:moeb_26/core/services/user_service.dart';
import 'package:moeb_26/core/utils/helpers.dart';
import 'package:moeb_26/data/models/service_area_model.dart';

class ServiceAreaController extends GetxController {
  final ServiceAreaService _serviceAreasService = Get.put(ServiceAreaService());

  RxList<ServiceAreaModel> serviceAreas = <ServiceAreaModel>[].obs;
  var isLoading = false.obs;
  var isMoreLoading = false.obs;
  var nextCursor = RxnString();
  var hasMore = false.obs;

  final ScrollController scrollController = ScrollController();

  // Selected service area name
  var selectedAreaName = "".obs;
  var isUpdating = false.obs;

  @override
  void onInit() {
    super.onInit();
    _initCurrentServiceArea();
    fetchServiceAreas();
    scrollController.addListener(_onScroll);
  }

  void _initCurrentServiceArea() {
    // Current service area initialization if needed
  }

  void selectServiceArea(String areaName) {
    selectedAreaName.value = areaName;
  }

  Future<void> updateServiceArea() async {
    if (selectedAreaName.value.isEmpty) {
      Helpers.showCustomSnackBar(
        "Please select a service area first",
        isError: true,
      );
      return;
    }

    try {
      isUpdating.value = true;
      final response = await _serviceAreasService.updateServiceArea(
        selectedAreaName.value,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.back();
        Helpers.showCustomSnackBar(
          "Service area updated successfully",
          isError: false,
        );

        try {
          Get.find<UserService>().fetchUserId();
        } catch (e) {
          debugPrint("Safe to ignore: User profile refresh failed $e");
        }
      } else {
        Helpers.showCustomSnackBar(
          response.data?['message'] ?? "Failed to update service area",
          isError: true,
        );
      }
    } catch (e) {
      debugPrint("Error updating service area: $e");
      Helpers.showCustomSnackBar(
        "Something went wrong while updating",
        isError: true,
      );
    } finally {
      isUpdating.value = false;
    }
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  Future<void> _onScroll() {
    if (!scrollController.hasClients ||
        scrollController.positions.length != 1) {
      return Future.value();
    }
    if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 200 &&
        !isLoading.value &&
        !isMoreLoading.value &&
        hasMore.value &&
        nextCursor.value != null) {
      loadMoreServiceAreas();
    }
    return Future.value();
  }

  Future<void> fetchServiceAreas({bool isRefresh = false}) async {
    if (isLoading.value || isMoreLoading.value) return;

    if (isRefresh) {
      nextCursor.value = null;
    }

    try {
      if (nextCursor.value == null) {
        isLoading.value = true;
      } else {
        isMoreLoading.value = true;
      }

      final response = await _serviceAreasService.getAllServiceAreas();

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
            data: (response.data as List)
                .map(
                  (e) => ServiceAreaModel.fromJson(
                    e is Map ? Map<String, dynamic>.from(e) : {'areaName': e.toString()},
                  ),
                )
                .toList(),
          );
        } else {
          debugPrint("Service Areas API: Unknown data format: ${response.data}");
          return;
        }

        hasMore.value = data.cursor?.hasMore ?? false;
        nextCursor.value = data.cursor?.nextCursor;

        if (isRefresh || nextCursor.value == null) {
          serviceAreas.assignAll(data.data);
        } else {
          serviceAreas.addAll(data.data);
        }
        debugPrint("Service Areas loaded: ${serviceAreas.length} items");
      } else {
        debugPrint("Service Areas API Error: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Error fetching service areas: $e");
    } finally {
      isLoading.value = false;
      isMoreLoading.value = false;
    }
  }

  void loadMoreServiceAreas() {
    if (!isLoading.value &&
        !isMoreLoading.value &&
        hasMore.value &&
        nextCursor.value != null) {
      fetchServiceAreas();
    }
  }

  void toggleExpansion(int index) {
    if (index >= 0 && index < serviceAreas.length) {
      serviceAreas[index].isExpanded = !serviceAreas[index].isExpanded;
      serviceAreas.refresh();
    }
  }
}
