import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../Services/marketplace_service.dart';
import '../Model/Marketplace_model.dart';

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

  Future<void> listItem() async {
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
      final response = await _marketplaceService.createItem(
        title: titleController.text,
        price: priceController.text,
        condition: selectedCondition.value.isNotEmpty
            ? selectedCondition.value
            : null,
        location: locationController.text,
        description: descriptionController.text.isNotEmpty
            ? descriptionController.text
            : null,
        photos: selectedImage.value != null ? [selectedImage.value!] : null,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.back();
        Get.snackbar(
          "Success",
          "Item listed successfully!",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xff1A1A1A),
          colorText: Colors.white,
        );
        _clearFields();
        fetchItems(); // Refresh the list
      } else {
        Get.snackbar(
          "Error",
          "Failed to list item: ${response.statusMessage ?? 'Unknown error'}",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print("Error listing item: $e");
      Get.snackbar(
        "Error",
        "An error occurred while listing the item",
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

  @override
  void onClose() {
    titleController.dispose();
    priceController.dispose();
    locationController.dispose();
    descriptionController.dispose();
    super.onClose();
  }
}
