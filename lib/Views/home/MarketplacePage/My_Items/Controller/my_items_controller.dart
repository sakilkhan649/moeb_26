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
    fetchMyProducts();
  }

  Future<void> fetchMyProducts() async {
    try {
      isLoading.value = true;
      // Reusing getAllItems but in a real app this might be a specific endpoint
      // for the current user's products. For now, we'll fetch all.
      final response = await _marketplaceService.getAllItems();

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
}
