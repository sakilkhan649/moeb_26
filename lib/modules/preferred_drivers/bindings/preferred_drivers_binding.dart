import 'package:get/get.dart';
import '../controllers/preferred_drivers_controller.dart';

class PreferredDriversBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PreferredDriversController());
  }
}
