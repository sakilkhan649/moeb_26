import 'package:get/get.dart';
import '../controllers/deals_controller.dart';

class DealsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DealsController());
  }
}
