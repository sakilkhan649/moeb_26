import 'package:get/get.dart';
import 'package:moeb_26/modules/my_items/controllers/my_items_controller.dart';

class MyItemsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MyItemsController());
  }
}
