import 'package:get/get.dart';
import 'package:moeb_26/modules/market_place/controllers/market_place_controller.dart';

class MarketPlaceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MarketplaceController());
  }
}
