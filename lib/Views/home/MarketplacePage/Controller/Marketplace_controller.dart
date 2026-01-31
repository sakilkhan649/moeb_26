import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../Utils/app_images.dart';
import '../Model/Marketplace_model.dart';

class MarketplaceController extends GetxController {
  var allItems = <MarketplaceItem>[].obs;
  var filteredItems = <MarketplaceItem>[].obs;

  // Sell Item Form States
  final RxString selectedCondition = "New".obs;
  final List<String> conditions = [
    "New",
    "Like New",
    "Excellent",
    "Good",
    "Fair",
  ];

  final TextEditingController titleController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  void updateCondition(String condition) {
    selectedCondition.value = condition;
  }

  void listItem() {
    // Logic to add item (mocked for now)
    Get.back();
    Get.snackbar(
      "Success",
      "Item listed successfully!",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xff1A1A1A),
      colorText: Colors.white,
    );
  }

  @override
  void onInit() {
    super.onInit();
    // Initialize with dummy data based on the design
    allItems.assignAll([
      MarketplaceItem(
        name: "Professional Car Phone Mount",
        price: "25",
        rating: 5.0,
        imagePath: AppImages.car_image,
        condition: "New",
      ),
      MarketplaceItem(
        name: "Leather Seat Covers",
        price: "25",
        rating: 5.0,
        imagePath: AppImages.set_image,
        condition: "New",
      ),
      MarketplaceItem(
        name: "Car Back Light (Red)",
        price: "25",
        rating: 5.0,
        imagePath: AppImages.back_light_image,
        condition: "New",
      ),
      MarketplaceItem(
        name: "Leather Seat Covers",
        price: "25",
        rating: 5.0,
        imagePath: AppImages.leather_image,
        condition: "New",
      ),
    ]);
    filteredItems.assignAll(allItems);
  }

  void searchItems(String query) {
    if (query.isEmpty) {
      filteredItems.assignAll(allItems);
    } else {
      filteredItems.assignAll(
        allItems
            .where(
              (item) => item.name.toLowerCase().contains(query.toLowerCase()),
            )
            .toList(),
      );
    }
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
