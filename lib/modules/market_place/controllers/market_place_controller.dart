import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moeb_26/core/utils/media_picker_helper.dart';
import 'package:moeb_26/core/services/marketplace_service.dart';
import 'package:moeb_26/core/utils/helpers.dart';
import 'package:moeb_26/data/models/market_place_model.dart';
import 'package:moeb_26/modules/my_items/controllers/my_items_controller.dart'
    as my_items;

class MarketplaceController extends GetxController {
  final MarketplaceService _marketplaceService = Get.put(MarketplaceService());

  var allItems = <ItemData>[].obs;
  var filteredItems = <ItemData>[].obs;
  var isLoading = false.obs;
  var isLoadMore = false.obs;

  // Strict Cursor Pagination
  String? nextCursor;
  bool hasMore = true;
  String currentQuery = "";
  final RxString selectedFilterCondition = "".obs;

  final ScrollController scrollController = ScrollController();

  // Sell Item Form States
  final RxString selectedCondition = "".obs;
  final List<String> conditions = [
    "New",
    "Used",
    "Refurbished",
  ];

  final TextEditingController titleController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  final RxList<File> selectedImages = <File>[].obs;
  final RxList<String> existingImagePaths = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchItems();
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
        !isLoading.value &&
        !isLoadMore.value &&
        hasMore &&
        nextCursor != null &&
        nextCursor!.isNotEmpty) {
      loadMoreItems();
    }
  }

  Future<void> fetchItems({String? query, String? condition}) async {
    try {
      isLoading.value = true;
      nextCursor = null;
      hasMore = true;
      currentQuery = query ?? currentQuery;
      final cond = condition ?? (selectedFilterCondition.value.isNotEmpty ? selectedFilterCondition.value : null);

      final response = await _marketplaceService.getAllItems(
        searchTerm: currentQuery.isNotEmpty ? currentQuery : null,
        condition: cond,
        limit: 10,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final marketplaceModel = MarketplaceModel.fromJson(response.data);
        final items = marketplaceModel.data ?? [];

        nextCursor = marketplaceModel.cursor?.nextCursor;
        hasMore = marketplaceModel.cursor?.hasMore ?? (nextCursor != null && nextCursor!.isNotEmpty);

        allItems.assignAll(items);
        filteredItems.assignAll(items);
      }
    } catch (e) {
      print("Error fetching items: $e");
      Helpers.showCustomSnackBar("Failed to fetch marketplace items", isError: true);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMoreItems() async {
    if (!hasMore || isLoadMore.value || nextCursor == null || nextCursor!.isEmpty) return;

    try {
      isLoadMore.value = true;
      final cond = selectedFilterCondition.value.isNotEmpty ? selectedFilterCondition.value : null;

      final response = await _marketplaceService.getAllItems(
        searchTerm: currentQuery.isNotEmpty ? currentQuery : null,
        condition: cond,
        cursor: nextCursor,
        limit: 10,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final marketplaceModel = MarketplaceModel.fromJson(response.data);
        final items = marketplaceModel.data ?? [];

        nextCursor = marketplaceModel.cursor?.nextCursor;
        hasMore = marketplaceModel.cursor?.hasMore ?? (nextCursor != null && nextCursor!.isNotEmpty);

        allItems.addAll(items);
        filteredItems.assignAll(allItems);
      }
    } catch (e) {
      print("Error loading more items: $e");
    } finally {
      isLoadMore.value = false;
    }
  }

  void searchItems(String query) {
    currentQuery = query;
    fetchItems(query: query);
  }

  void filterByCondition(String condition) {
    if (selectedFilterCondition.value == condition) {
      selectedFilterCondition.value = "";
    } else {
      selectedFilterCondition.value = condition;
    }
    fetchItems(condition: selectedFilterCondition.value.isNotEmpty ? selectedFilterCondition.value : null);
  }

  Future<void> pickImages(BuildContext context) async {
    final List<File>? images = await MediaPickerHelper.pickMultiImages(context);
    if (images != null && images.isNotEmpty) {
      for (var image in images) {
        final compressed = await Helpers.compressImage(image);
        selectedImages.add(compressed);
      }
    }
  }

  void updateCondition(String condition) {
    if (selectedCondition.value == condition) {
      selectedCondition.value = "";
    } else {
      selectedCondition.value = condition;
    }
  }

  Future<void> listItem({String? editItemId}) async {
    if (titleController.text.trim().isEmpty ||
        priceController.text.trim().isEmpty ||
        locationController.text.trim().isEmpty) {
      Helpers.showCustomSnackBar("Please fill title, price, and location", isError: true);
      return;
    }

    try {
      isLoading.value = true;
      final response = editItemId == null
          ? await _marketplaceService.createItem(
              title: titleController.text.trim(),
              price: priceController.text.trim(),
              condition: selectedCondition.value.isNotEmpty
                  ? selectedCondition.value
                  : null,
              location: locationController.text.trim(),
              description: descriptionController.text.trim().isNotEmpty
                  ? descriptionController.text.trim()
                  : null,
              photos: selectedImages.isNotEmpty
                  ? selectedImages.toList()
                  : null,
            )
          : await _marketplaceService.updateItem(
              itemId: editItemId,
              title: titleController.text.trim(),
              price: priceController.text.trim(),
              condition: selectedCondition.value.isNotEmpty
                  ? selectedCondition.value
                  : null,
              location: locationController.text.trim(),
              description: descriptionController.text.trim().isNotEmpty
                  ? descriptionController.text.trim()
                  : null,
              photos: selectedImages.isNotEmpty
                  ? selectedImages.toList()
                  : null,
            );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.back();
        Helpers.showCustomSnackBar(
          editItemId == null
              ? "Item listed successfully!"
              : "Item updated successfully!",
          isError: false,
        );
        clearFields();
        fetchItems(); // Refresh the general marketplace list

        // Also refresh My Items list if that controller is active
        if (Get.isRegistered<my_items.MyItemsController>()) {
          Get.find<my_items.MyItemsController>().fetchMyItems();
        }
      } else {
        Helpers.showCustomSnackBar(
          "Failed to ${editItemId == null ? 'list' : 'update'} item: ${response.statusMessage ?? 'Unknown error'}",
          isError: true,
        );
      }
    } catch (e) {
      print("Error processing item: $e");
      Helpers.showCustomSnackBar(
        "An error occurred while ${editItemId == null ? 'listing' : 'updating'} the item",
        isError: true,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void clearFields() {
    titleController.clear();
    priceController.clear();
    locationController.clear();
    descriptionController.clear();
    selectedImages.clear();
    existingImagePaths.clear();
    selectedCondition.value = "";
  }

  void prefillForEdit(
    String title,
    String price,
    String location,
    String condition,
    String description,
    List<String> photos,
  ) {
    titleController.text = title;
    priceController.text = price;
    locationController.text = location;
    descriptionController.text = description;
    existingImagePaths.assignAll(photos);
    if (condition.isNotEmpty && conditions.contains(condition)) {
      selectedCondition.value = condition;
    } else {
      selectedCondition.value = "";
    }
    selectedImages.clear();
  }
}
