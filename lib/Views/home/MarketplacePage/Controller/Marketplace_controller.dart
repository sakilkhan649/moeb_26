import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../Services/marketplace_service.dart';
import '../Model/Marketplace_model.dart';
import '../My_Items/Controller/my_items_controller.dart' as my_items;

class MarketplaceController extends GetxController {
  final MarketplaceService _marketplaceService = Get.put(MarketplaceService());

  var allItems = <MarketplaceItem>[].obs;
  var filteredItems = <MarketplaceItem>[].obs;
  var isLoading = false.obs;

  // Sell Item Form States
  final RxString selectedCondition = "New".obs;
  final List<String> conditions = [
    "New",
    "Used", // Changed to match API/Postman
    "Refurbished",
  ];

  final TextEditingController titleController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  final Rxn<File> selectedImage = Rxn<File>();
  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    fetchItems();
  }

  Future<void> fetchItems({String? query}) async {
    try {
      isLoading.value = true;
      final response = await _marketplaceService.getAllItems(searchTerm: query);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final List<dynamic> data = response.data['data'];
        final items = data
            .map((json) => MarketplaceItem.fromJson(json))
            .toList();
        allItems.assignAll(items);
        filteredItems.assignAll(items);
      }
    } catch (e) {
      print("Error fetching items: $e");
      Get.snackbar(
        "Error",
        "Failed to fetch marketplace items",
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void searchItems(String query) {
    // We can either filter locally or fetch from API
    // Let's fetch from API as it has search support
    fetchItems(query: query);
  }

  Future<void> pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      selectedImage.value = File(image.path);
    }
  }

  void updateCondition(String condition) {
    selectedCondition.value = condition;
  }

  Future<void> listItem({String? editItemId}) async {
    if (titleController.text.isEmpty ||
        priceController.text.isEmpty ||
        locationController.text.isEmpty) {
      Get.snackbar(
        "Error",
        "Please fill title, price, and location",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isLoading.value = true;
      final response = editItemId == null
          ? await _marketplaceService.createItem(
              title: titleController.text,
              price: priceController.text,
              condition: selectedCondition.value.isNotEmpty
                  ? selectedCondition.value
                  : null,
              location: locationController.text,
              description: descriptionController.text.isNotEmpty
                  ? descriptionController.text
                  : null,
              photos: selectedImage.value != null
                  ? [selectedImage.value!]
                  : null,
            )
          : await _marketplaceService.updateItem(
              itemId: editItemId,
              title: titleController.text,
              price: priceController.text,
              condition: selectedCondition.value.isNotEmpty
                  ? selectedCondition.value
                  : null,
              location: locationController.text,
              description: descriptionController.text.isNotEmpty
                  ? descriptionController.text
                  : null,
              photos: selectedImage.value != null
                  ? [selectedImage.value!]
                  : null,
              // status could also be updated here if needed
            );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.back();
        Get.snackbar(
          "Success",
          editItemId == null
              ? "Item listed successfully!"
              : "Item updated successfully!",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xff1A1A1A),
          colorText: Colors.white,
        );
        _clearFields();
        fetchItems(); // Refresh the general list

        // Also refresh My Items list if that controller is active
        if (Get.isRegistered<my_items.MyItemsController>()) {
          Get.find<my_items.MyItemsController>().fetchMyItems();
        }
      } else {
        Get.snackbar(
          "Error",
          "Failed to ${editItemId == null ? 'list' : 'update'} item: ${response.statusMessage ?? 'Unknown error'}",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print("Error processing item: $e");
      Get.snackbar(
        "Error",
        "An error occurred while ${editItemId == null ? 'listing' : 'updating'} the item",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void _clearFields() {
    titleController.clear();
    priceController.clear();
    locationController.clear();
    descriptionController.clear();
    selectedImage.value = null;
    selectedCondition.value = "New";
  }

  void prefillForEdit(
    String title,
    String price,
    String location,
    String condition,
    String description,
  ) {
    titleController.text = title;
    priceController.text = price;
    locationController.text = location;
    descriptionController.text = description;
    if (condition.isNotEmpty && conditions.contains(condition)) {
      selectedCondition.value = condition;
    } else {
      selectedCondition.value = "Used";
    }
    selectedImage.value =
        null; // Can't easily prefill remote file into File system without download
  }

  @override
  void onClose() {
    titleController.dispose();
    priceController.dispose();
    locationController.dispose();
    descriptionController.dispose();
    super.onClose();
  }
}
