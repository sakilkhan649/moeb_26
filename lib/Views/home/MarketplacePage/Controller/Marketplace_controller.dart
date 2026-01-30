import 'package:get/get.dart';
import '../../../../Utils/app_images.dart';
import '../Model/Marketplace_model.dart';

class MarketplaceController extends GetxController {
  var allItems = <MarketplaceItem>[].obs;
  var filteredItems = <MarketplaceItem>[].obs;

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
}
