import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../Services/marketplace_service.dart';
import '../Model/my_items_model.dart';

class MyItemsController extends GetxController {
  final MarketplaceService _marketplaceService = Get.put(MarketplaceService());

  var myItems = <MyItemsModel>[].obs;
  var isLoading = false.obs;
  var isLoadMore = false.obs;
  var currentPage = 1;
  var totalPage = 1;

  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    fetchMyItems();
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
        !isLoading.value &&
        !isLoadMore.value &&
        currentPage < totalPage) {
      loadMoreMyItems();
    }
  }

  Future<void> fetchMyItems() async {
    try {
      isLoading.value = true;
      currentPage = 1;
      final response = await _marketplaceService.getMyItems(page: currentPage);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final myItemsResponse = MyItemsResponse.fromJson(response.data);
        final items = myItemsResponse.data ?? [];
        totalPage = myItemsResponse.pagination?.totalPage ?? 1;

        myItems.assignAll(items);
      }
    } catch (e) {
      print("Error fetching my items: $e");
      Get.snackbar(
        "Error",
        "Failed to fetch your items",
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMoreMyItems() async {
    try {
      isLoadMore.value = true;
      currentPage++;
      final response = await _marketplaceService.getMyItems(page: currentPage);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final myItemsResponse = MyItemsResponse.fromJson(response.data);
        final items = myItemsResponse.data ?? [];

        myItems.addAll(items);
      }
    } catch (e) {
      print("Error loading more items: $e");
      currentPage--; // Reset page on error
    } finally {
      isLoadMore.value = false;
    }
  }

  Future<void> deleteItem(String id) async {
    try {
      final response = await _marketplaceService.deleteItem(id);

      if (response.statusCode == 200 || response.statusCode == 201) {
        myItems.removeWhere((item) => item.id == id);
        Get.back(); // Close the dialog
        Get.snackbar(
          "Success",
          "Item deleted successfully",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.back();
        Get.snackbar(
          "Error",
          "Failed to delete item",
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.back();
      print("Error deleting item: $e");
      Get.snackbar(
        "Error",
        "An error occurred while deleting",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
