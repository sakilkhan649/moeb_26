import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../Services/marketplace_service.dart';
import '../Model/my_items_model.dart';

class MyItemsController extends GetxController {
  final MarketplaceService _marketplaceService = Get.put(MarketplaceService());

  var myItems = <MyItemsModel>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchMyItems();
  }

  Future<void> fetchMyItems() async {
    try {
      isLoading.value = true;
      final response = await _marketplaceService.getMyItems();

      if (response.statusCode == 200 || response.statusCode == 201) {
        final List<dynamic> data = response.data['data'];
        final items = data.map((json) => MyItemsModel.fromJson(json)).toList();
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
